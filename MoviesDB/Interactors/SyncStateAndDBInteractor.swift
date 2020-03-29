//
//  SyncStateAndDBService.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 29.03.2020.
//  Copyright © 2020 Dmitry Kocherovets. All rights reserved.
//

import Foundation
import CoreData

public protocol AnyDBSync {

    func execute(trunk: Trunk, interactor: Any)
}

public protocol DBSync: AnyDBSync {

    associatedtype Interactor

    func execute(trunk: Trunk, interactor: Interactor)
}

public extension DBSync {

    func execute(trunk: Trunk, interactor: Any) {

        execute(trunk: trunk, interactor: interactor as! Interactor)
    }
}

class SyncStateAndDBInteractor: Interactor<State> {

    fileprivate let db: DBService

    init(store: Store<State>, db: DBService) {

        self.db = db

        super.init(store: store)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.contextSave(_:)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
    }

    override var sideEffects: [AnySideEffect] {
        [
//            SyncNowPlayingMoviesSE(),
        ]
    }

    var dbSyncs: [AnyDBSync] {
        [
            NowPlayingDBSync(),
            UpcomingDBSync(),
            TrendingDBSync(),
            PopularDBSync()
        ]
    }

    @objc func contextSave(_ notification: Notification) {

        print("---contextSave---")
        if
            let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            !insertedObjects.isEmpty
        {
            print(insertedObjects)
        }
        if
            let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
            !updatedObjects.isEmpty
        {
            print(updatedObjects)
        }
        if
            let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            !deletedObjects.isEmpty
        {
            print(deletedObjects)
        }
        if
            let refreshedObjects = notification.userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject>,
            !refreshedObjects.isEmpty
        {
            print(refreshedObjects)
        }
        if
            let invalidatedObjects = notification.userInfo?[NSInvalidatedObjectsKey] as? Set<NSManagedObject>,
            !invalidatedObjects.isEmpty
        {
            print(invalidatedObjects)
        }
        if
            let areInvalidatedAllObjects = notification.userInfo?[NSInvalidatedAllObjectsKey] as? Bool
        {
            print(areInvalidatedAllObjects)
        }

        for dbSync in dbSyncs {
            dbSync.execute(trunk: self, interactor: self)
        }
    }
}

extension SyncStateAndDBInteractor {

//    struct SyncNowPlayingMoviesSE: SideEffect {
//
//        func condition(box: StateBox<State>) -> Bool {
//
//            if let action = box.lastAction as? MoviesState.LoadAction,
//                action.category == .nowPlaying,
//                box.isNew(keyPath: \.moviesState.loadNowPlayingMoviesState) {
//
//                return true
//            }
//            return false
//        }
//
//        func execute(box: StateBox<State>, trunk: Trunk, interactor: LoadMoviesInteractor) {
//
//            _ = interactor.api.request(target: UnauthorizedAPI.nowPlaying(page: box.state.moviesState.nowPlayingPage + 1))
//            {
//                (result: Result<ServerModels.NowPlaying, Error>) in
//
//                switch result {
//                case .success(let data):
//                    trunk.dispatch(MoviesState.SaveToDBAction(category: .nowPlaying, movies: data.results))
//                case .failure(let error):
//                    trunk.dispatch(MoviesState.FinishLoadingAction(category: .nowPlaying, error: error))
//                }
//            }
//        }
//    }
}

extension SyncStateAndDBInteractor {

    struct NowPlayingDBSync: DBSync {

        func execute(trunk: Trunk, interactor: SyncStateAndDBInteractor) {

            let movies = interactor.db.movies(category: .nowPlaying)
            trunk.dispatch(MoviesState.SetMoviesAction(category: .nowPlaying, movies: movies))
        }
    }

    struct UpcomingDBSync: DBSync {

        func execute(trunk: Trunk, interactor: SyncStateAndDBInteractor) {

            let movies = interactor.db.movies(category: .upcoming)
            trunk.dispatch(MoviesState.SetMoviesAction(category: .upcoming, movies: movies))
        }
    }

    struct TrendingDBSync: DBSync {

        func execute(trunk: Trunk, interactor: SyncStateAndDBInteractor) {

            let movies = interactor.db.movies(category: .trending)
            trunk.dispatch(MoviesState.SetMoviesAction(category: .trending, movies: movies))
        }
    }

    struct PopularDBSync: DBSync {

        func execute(trunk: Trunk, interactor: SyncStateAndDBInteractor) {

            let movies = interactor.db.movies(category: .popular)
            trunk.dispatch(MoviesState.SetMoviesAction(category: .popular, movies: movies))
        }
    }

}

extension MoviesState {

    struct SetMoviesAction: Action {

        var category: MoviesState.Category
        var movies: [Movie]

        func updateState(_ state: inout State) {

            switch category {
            case .nowPlaying:
                state.moviesState.nowPlayingMovies = movies
            case .upcoming:
                state.moviesState.upcomingMovies = movies
            case .trending:
                state.moviesState.trendingMovies = movies
            case .popular:
                state.moviesState.popularMovies = movies
            }
        }
    }

}

extension MoviesState {

    struct Movie: Equatable {
        var category: MoviesState.Category
        var id: Int
        var title: String
        var overview: String
        var releaseDate: String
        var votePercentage: Int
        var posterPath: String?

        init(movieDB: MovieDB) {
            self.category = MoviesState.Category(rawValue: Int(movieDB.category))!
            self.id = Int(movieDB.id)
            self.title = movieDB.title
            self.overview = movieDB.overview
            self.releaseDate = movieDB.releaseDate
            self.votePercentage = Int(movieDB.votePercentage)
            self.posterPath = movieDB.posterPath
        }
    }
}
