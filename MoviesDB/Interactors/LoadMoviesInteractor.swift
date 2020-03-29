//
//  LoadMoviesInteractor.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 28.03.2020.
//  Copyright © 2020 Dmitry Kocherovets. All rights reserved.
//

import Foundation
import RedSwift
import ReduxVM

extension MoviesState {

    enum LoadMovies: Equatable {
        case request(category: MoviesState.Category)
        case saveToDB(category: MoviesState.Category, movies: [ServerModels.Movie])
        case error(error: Error)
        case none

        static func == (lhs: MoviesState.LoadMovies, rhs: MoviesState.LoadMovies) -> Bool {
            switch (lhs, rhs) {
            case (.request(let categoryL), .request(let categoryR)):
                return categoryL == categoryR
            case (.saveToDB(let categoryL, let moviesL), .saveToDB(let categoryR, let moviesR)):
                return categoryL == categoryR && moviesL == moviesR
            case (.error, .error):
                return true
            case (.none, .none):
                return true
            default:
                return false
            }
        }
    }
}

extension MoviesState {

    struct LoadAction: Action {

        let category: Category

        func updateState(_ state: inout State) {
            switch category {
            case .nowPlaying:
                state.moviesState.loadNowPlayingMoviesState = .request(category: category)
                state.moviesState.nowPlayingPage += 1
            case .upcoming:
                state.moviesState.loadUpcomingMoviesState = .request(category: category)
                state.moviesState.upcomingPage += 1
            case .trending:
                state.moviesState.loadTrendingMoviesState = .request(category: category)
                state.moviesState.trendingPage += 1
            case .popular:
                state.moviesState.loadPopularMoviesState = .request(category: category)
                state.moviesState.popularPage += 1
            }
        }
    }

    struct SaveToDBAction: Action {

        let category: Category
        let movies: [ServerModels.Movie]

        func updateState(_ state: inout State) {
            switch category {
            case .nowPlaying:
                state.moviesState.loadNowPlayingMoviesState = .saveToDB(category: category, movies: movies)
            case .upcoming:
                state.moviesState.loadUpcomingMoviesState = .saveToDB(category: category, movies: movies)
            case .trending:
                state.moviesState.loadTrendingMoviesState = .saveToDB(category: category, movies: movies)
            case .popular:
                state.moviesState.loadPopularMoviesState = .saveToDB(category: category, movies: movies)
            }
        }
    }

    struct FinishLoadingAction: Action {

        let category: Category
        let error: Error?

        func updateState(_ state: inout State) {

            if let error = error {
                switch category {
                case .nowPlaying:
                    state.moviesState.loadNowPlayingMoviesState = .error(error: error)
                case .upcoming:
                    state.moviesState.loadUpcomingMoviesState = .error(error: error)
                case .trending:
                    state.moviesState.loadTrendingMoviesState = .error(error: error)
                case .popular:
                    state.moviesState.loadPopularMoviesState = .error(error: error)
                }
            }
            else {
                switch category {
                case .nowPlaying:
                    state.moviesState.loadNowPlayingMoviesState = .none
                case .upcoming:
                    state.moviesState.loadUpcomingMoviesState = .none
                case .trending:
                    state.moviesState.loadTrendingMoviesState = .none
                case .popular:
                    state.moviesState.loadPopularMoviesState = .none
                }
            }
        }
    }
}

class LoadMoviesInteractor: Interactor<State> {

    fileprivate let api: UnauthorizedAPI.Type
    fileprivate let db: DBService

    init(store: Store<State>, api: UnauthorizedAPI.Type, db: DBService) {

        self.api = api
        self.db = db

        super.init(store: store)
    }

    override var sideEffects: [AnySideEffect] {
        [
            LoadNowPlayingMoviesSE(),
            SaveToDBNowPlayingMoviesSE(),
            
            LoadUpcomingMoviesSE(),
            SaveToDBUpcomingMoviesSE(),
            
            LoadTrendingMoviesSE(),
            SaveToDBTrendingMoviesSE(),
            
            LoadPopularMoviesSE(),
            SaveToDBPopularMoviesSE(),
        ]
    }

    deinit {
    }
}

extension LoadMoviesInteractor {

    struct LoadNowPlayingMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            if let action = box.lastAction as? MoviesState.LoadAction,
                action.category == .nowPlaying,
                box.isNew(keyPath: \.moviesState.loadNowPlayingMoviesState) {

                return true
            }
            return false
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: LoadMoviesInteractor) {

            _ = interactor.api.request(target: UnauthorizedAPI.nowPlaying(page: box.state.moviesState.nowPlayingPage))
            {
                (result: Result<ServerModels.NowPlaying, Error>) in

                switch result {
                case .success(let data):
                    trunk.dispatch(MoviesState.SaveToDBAction(category: .nowPlaying, movies: data.results))
                case .failure(let error):
                    trunk.dispatch(MoviesState.FinishLoadingAction(category: .nowPlaying, error: error))
                }
            }
        }
    }

    struct SaveToDBNowPlayingMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            return (box.lastAction as? MoviesState.SaveToDBAction)?.category == .nowPlaying
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: LoadMoviesInteractor) {

            guard case .saveToDB(_, let movies) = box.state.moviesState.loadNowPlayingMoviesState else { return }

            let error = interactor.db.saveMovies(movies: movies, category: .nowPlaying)

            trunk.dispatch(MoviesState.FinishLoadingAction(category: .nowPlaying, error: error))
        }
    }

    struct LoadUpcomingMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            if let action = box.lastAction as? MoviesState.LoadAction,
                action.category == .upcoming,
                box.isNew(keyPath: \.moviesState.loadUpcomingMoviesState) {

                return true
            }
            return false
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: LoadMoviesInteractor) {

            _ = interactor.api.request(target: UnauthorizedAPI.upcoming(page: box.state.moviesState.upcomingPage))
            {
                (result: Result<ServerModels.Upcoming, Error>) in

                switch result {
                case .success(let data):
                    trunk.dispatch(MoviesState.SaveToDBAction(category: .upcoming, movies: data.results))
                case .failure(let error):
                    trunk.dispatch(MoviesState.FinishLoadingAction(category: .upcoming, error: error))
                }
            }
        }
    }

    struct SaveToDBUpcomingMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            return (box.lastAction as? MoviesState.SaveToDBAction)?.category == .upcoming
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: LoadMoviesInteractor) {

            guard case .saveToDB(_, let movies) = box.state.moviesState.loadUpcomingMoviesState else { return }

            let error = interactor.db.saveMovies(movies: movies, category: .upcoming)

            trunk.dispatch(MoviesState.FinishLoadingAction(category: .upcoming, error: error))
        }
    }

    struct LoadTrendingMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            if let action = box.lastAction as? MoviesState.LoadAction,
                action.category == .trending,
                box.isNew(keyPath: \.moviesState.loadTrendingMoviesState) {

                return true
            }
            return false
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: LoadMoviesInteractor) {

            _ = interactor.api.request(target: UnauthorizedAPI.trending(page: box.state.moviesState.trendingPage))
            {
                (result: Result<ServerModels.Trending, Error>) in

                switch result {
                case .success(let data):
                    trunk.dispatch(MoviesState.SaveToDBAction(category: .trending, movies: data.results))
                case .failure(let error):
                    trunk.dispatch(MoviesState.FinishLoadingAction(category: .trending, error: error))
                }
            }
        }
    }

    struct SaveToDBTrendingMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            return (box.lastAction as? MoviesState.SaveToDBAction)?.category == .trending
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: LoadMoviesInteractor) {

            guard case .saveToDB(_, let movies) = box.state.moviesState.loadTrendingMoviesState else { return }

            let error = interactor.db.saveMovies(movies: movies, category: .trending)

            trunk.dispatch(MoviesState.FinishLoadingAction(category: .trending, error: error))
        }
    }

    struct LoadPopularMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            if let action = box.lastAction as? MoviesState.LoadAction,
                action.category == .popular,
                box.isNew(keyPath: \.moviesState.loadPopularMoviesState) {

                return true
            }
            return false
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: LoadMoviesInteractor) {

            _ = interactor.api.request(target: UnauthorizedAPI.popular(page: box.state.moviesState.popularPage))
            {
                (result: Result<ServerModels.Popular, Error>) in

                switch result {
                case .success(let data):
                    trunk.dispatch(MoviesState.SaveToDBAction(category: .popular, movies: data.results))
                case .failure(let error):
                    trunk.dispatch(MoviesState.FinishLoadingAction(category: .popular, error: error))
                }
            }
        }
    }

    struct SaveToDBPopularMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            return (box.lastAction as? MoviesState.SaveToDBAction)?.category == .popular
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: LoadMoviesInteractor) {

            guard case .saveToDB(_, let movies) = box.state.moviesState.loadPopularMoviesState else { return }

            let error = interactor.db.saveMovies(movies: movies, category: .popular)

            trunk.dispatch(MoviesState.FinishLoadingAction(category: .popular, error: error))
        }
    }
}
