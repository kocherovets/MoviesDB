//
//  MoviesState.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 25.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import Foundation
import RedSwift
import Moya

struct MoviesState: StateType, Equatable {

    enum Category: Int {
        case nowPlaing = 0
        case upcoming = 1
        case trending = 2
        case popular = 3
    }
    var selectedCategory = Category.nowPlaing

    var nowPlaingMovies = [ServerModels.Movie]()
    var upcomingMovies = [ServerModels.Movie]()
    var trendingMovies = [ServerModels.Movie]()
    var popularMovies = [ServerModels.Movie]()

    var isLoading = false
    
    var selectedCategoryMovies: [ServerModels.Movie] {
        switch selectedCategory {
        case .nowPlaing:
            return nowPlaingMovies
        case .upcoming:
            return upcomingMovies
        case .trending:
            return trendingMovies
        case .popular:
            return popularMovies
        }
    }
}

extension MoviesState {

    struct LoadAction: Action {

        func updateState(_ state: inout State) {
            state.moviesState.isLoading = true
        }
    }

    struct ErrorLoadingAction: Action {

        func updateState(_ state: inout State) {
            state.moviesState.isLoading = false
        }
    }

    struct ChangeSelectedCategoryAction: Action {

        var selectedCategory: Category

        func updateState(_ state: inout State) {

            state.moviesState.selectedCategory = selectedCategory
        }
    }

    struct AppendNowPlayingMoviesAction: Action {

        var movies: [ServerModels.Movie]

        func updateState(_ state: inout State) {
            state.moviesState.isLoading = false
            state.moviesState.nowPlaingMovies.append(contentsOf: movies)
        }
    }

    struct LoadNowPlayingMoviesSE: SideEffect {

        func sideEffect(state: State, trunk: Trunk, dependencies: DependencyContainer) {

            trunk.dispatch(LoadAction())

            _ = UnauthorizedAPI.request(target: UnauthorizedAPI.nowPlaying) { (result: Result<ServerModels.NowPlaying, Error>) in
                switch result {
                case .success(let data):
                    trunk.dispatch(AppendNowPlayingMoviesAction(movies: data.results))
                case .failure:
                    trunk.dispatch(ErrorLoadingAction())
                }
            }
        }
    }

    struct AppendUpcomingMoviesAction: Action {

        var movies: [ServerModels.Movie]

        func updateState(_ state: inout State) {
            state.moviesState.isLoading = false
            state.moviesState.upcomingMovies.append(contentsOf: movies)
        }
    }

    struct LoadUpcomingMoviesSE: SideEffect {

        func sideEffect(state: State, trunk: Trunk, dependencies: DependencyContainer) {

            trunk.dispatch(LoadAction())

            _ = UnauthorizedAPI.request(target: UnauthorizedAPI.upcoming) { (result: Result<ServerModels.Upcoming, Error>) in
                switch result {
                case .success(let data):
                    trunk.dispatch(AppendUpcomingMoviesAction(movies: data.results))
                case .failure:
                    trunk.dispatch(ErrorLoadingAction())
                }
            }
        }
    }

    struct AppendTrendingMoviesAction: Action {

        var movies: [ServerModels.Movie]

        func updateState(_ state: inout State) {
            state.moviesState.isLoading = false
            state.moviesState.trendingMovies.append(contentsOf: movies)
        }
    }

    struct LoadTrendingMoviesSE: SideEffect {

        func sideEffect(state: State, trunk: Trunk, dependencies: DependencyContainer) {

            trunk.dispatch(LoadAction())

            _ = UnauthorizedAPI.request(target: UnauthorizedAPI.trending) { (result: Result<ServerModels.Trending, Error>) in
                switch result {
                case .success(let data):
                    trunk.dispatch(AppendTrendingMoviesAction(movies: data.results))
                case .failure:
                    trunk.dispatch(ErrorLoadingAction())
                }
            }
        }
    }

    struct AppendPopularMoviesAction: Action {

          var movies: [ServerModels.Movie]

          func updateState(_ state: inout State) {
              state.moviesState.isLoading = false
              state.moviesState.popularMovies.append(contentsOf: movies)
          }
      }

      struct LoadPopularMoviesSE: SideEffect {

          func sideEffect(state: State, trunk: Trunk, dependencies: DependencyContainer) {

              trunk.dispatch(LoadAction())

              _ = UnauthorizedAPI.request(target: UnauthorizedAPI.trending) { (result: Result<ServerModels.Popular, Error>) in
                  switch result {
                  case .success(let data):
                      trunk.dispatch(AppendPopularMoviesAction(movies: data.results))
                  case .failure:
                      trunk.dispatch(ErrorLoadingAction())
                  }
              }
          }
      }
}
