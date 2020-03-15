//
//  NetService.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 25.01.2020.
//  Copyright © 2020 Dmitry Kocherovets. All rights reserved.
//

import Foundation
import RedSwift
import ReduxVM

class APIInteractor: Interactor<State> {

    let api = UnauthorizedAPI.self

    override var sideEffects: [AnySideEffect] {
        [
            LoadNowPlayingMoviesSE(),
            LoadUpcomingMoviesSE(),
            LoadTrendingMoviesSE(),
            LoadPopularMoviesSE(),
            
            CreateDetailsSE(),
        ]
    }

    deinit {
    }
}

extension APIInteractor {

    fileprivate struct LoadNowPlayingMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            if let action = box.lastAction as? MoviesState.LoadAction,
                action.category == .nowPlaying,
                box.isNew(keyPath: \.moviesState.isNowPlayingLoading) {

                return true
            }
            return false
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: APIInteractor) {

            _ = interactor.api.request(target: UnauthorizedAPI.nowPlaying(page: box.state.moviesState.nowPlayingPage + 1))
            {
                (result: Result<ServerModels.NowPlaying, Error>) in

                switch result {
                case .success(let data):
                    trunk.dispatch(MoviesState.AppendNowPlayingMoviesAction(movies: data.results))
                case .failure:
                    trunk.dispatch(MoviesState.ErrorLoadingAction(category: .nowPlaying))
                }
            }
        }
    }

    fileprivate struct LoadUpcomingMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            if let action = box.lastAction as? MoviesState.LoadAction,
                action.category == .upcoming,
                box.isNew(keyPath: \.moviesState.isUpcomingLoading) {

                return true
            }
            return false
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: APIInteractor) {

            _ = interactor.api.request(target: UnauthorizedAPI.upcoming(page: box.state.moviesState.upcomingPage + 1))
            {
                (result: Result<ServerModels.Upcoming, Error>) in

                switch result {
                case .success(let data):
                    trunk.dispatch(MoviesState.AppendUpcomingMoviesAction(movies: data.results))
                case .failure:
                    trunk.dispatch(MoviesState.ErrorLoadingAction(category: .upcoming))
                }
            }
        }
    }

    fileprivate struct LoadTrendingMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            if let action = box.lastAction as? MoviesState.LoadAction,
                action.category == .trending,
                box.isNew(keyPath: \.moviesState.isTrendingLoading) {

                return true
            }
            return false
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: APIInteractor) {

            _ = interactor.api.request(target: UnauthorizedAPI.trending(page: box.state.moviesState.trendingPage + 1))
            {
                (result: Result<ServerModels.Trending, Error>) in

                switch result {
                case .success(let data):
                    trunk.dispatch(MoviesState.AppendTrendingMoviesAction(movies: data.results))
                case .failure:
                    trunk.dispatch(MoviesState.ErrorLoadingAction(category: .trending))
                }
            }
        }
    }

    fileprivate struct LoadPopularMoviesSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            if let action = box.lastAction as? MoviesState.LoadAction,
                action.category == .popular,
                box.isNew(keyPath: \.moviesState.isPopularLoading) {

                return true
            }
            return false
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: APIInteractor) {

            _ = interactor.api.request(target: UnauthorizedAPI.popular(page: box.state.moviesState.popularPage + 1))
            {
                (result: Result<ServerModels.Popular, Error>) in

                switch result {
                case .success(let data):
                    trunk.dispatch(MoviesState.AppendPopularMoviesAction(movies: data.results))
                case .failure:
                    trunk.dispatch(MoviesState.ErrorLoadingAction(category: .popular))
                }
            }
        }
    }

    //
    
    fileprivate struct CreateDetailsSE: SideEffect {

        func condition(box: StateBox<State>) -> Bool {

            if let action = box.lastAction as? MovieState.CreateDetailsAction,
                let movieState = box.state.movieStates[action.uuid],
                movieState.isDetailsLoading,
                box.unsafeGetOldState()?.movieStates[action.uuid]?.isDetailsLoading != true {

                return true
            }
            return false
        }

        func execute(box: StateBox<State>, trunk: Trunk, interactor: APIInteractor) {

            guard let action = box.lastAction as? MovieState.CreateDetailsAction,
                let movieState = box.state.movieStates[action.uuid] else { return }

            _ = interactor.api.request(target: UnauthorizedAPI.movieDetail(movie: movieState.movieId))
            {
                (result: Result<ServerModels.MovieDetails, Error>) in

                switch result {
                case .success(let data):
                    trunk.dispatch(MovieState.AppendDetailsAction(details: data, uuid: action.uuid))
                case .failure:
                    trunk.dispatch(MovieState.ErrorLoadingAction(category: .details, uuid: action.uuid))
                }
            }
        }
    }
    
//    private func loadCredits(state: State, trunk: Trunk, dependencies: DependencyContainer) {
//
//    }
//    private func loadRecommended(state: State, trunk: Trunk, dependencies: DependencyContainer) {
//
//    }
//    private func loadSimilar(state: State, trunk: Trunk, dependencies: DependencyContainer) {
//
//    }
//    private func loadReview(state: State, trunk: Trunk, dependencies: DependencyContainer) {
//
//    }

}

