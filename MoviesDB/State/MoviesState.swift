//
//  MoviesState.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 25.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import Foundation
import Moya

struct MoviesState: StateType, Equatable {

    enum Category: Int {
        case nowPlaying = 0
        case upcoming = 1
        case trending = 2
        case popular = 3
    }
    var selectedCategory = Category.nowPlaying

    enum ViewMode {
        case general
        case allCategories
    }
    var viewMode = ViewMode.general

    var isNowPlayingLoading = false
    var nowPlayingPage: Int = 0
    var nowPlayingMovies = [ServerModels.Movie]()

    var isUpcomingLoading = false
    var upcomingPage: Int = 0
    var upcomingMovies = [ServerModels.Movie]()

    var isTrendingLoading = false
    var trendingPage: Int = 0
    var trendingMovies = [ServerModels.Movie]()

    var isPopularLoading = false
    var popularPage: Int = 0
    var popularMovies = [ServerModels.Movie]()

    var isLoading: Bool {
        return isNowPlayingLoading || isUpcomingLoading || isTrendingLoading || isPopularLoading
    }

    var selectedCategoryMovies: [ServerModels.Movie] {
        switch selectedCategory {
        case .nowPlaying:
            return nowPlayingMovies
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

        let category: Category

        func updateState(_ state: inout State) {
            switch category {
            case .nowPlaying:
                state.moviesState.isNowPlayingLoading = true
            case .upcoming:
                state.moviesState.isUpcomingLoading = true
            case .trending:
                state.moviesState.isTrendingLoading = true
            case .popular:
                state.moviesState.isPopularLoading = true
            }
        }
    }

    struct ErrorLoadingAction: Action {

        let category: Category

        func updateState(_ state: inout State) {
            switch category {
            case .nowPlaying:
                state.moviesState.isNowPlayingLoading = false
            case .upcoming:
                state.moviesState.isUpcomingLoading = false
            case .trending:
                state.moviesState.isTrendingLoading = false
            case .popular:
                state.moviesState.isPopularLoading = false
            }
        }
    }

    struct ChangeSelectedCategoryAction: Action {

        var selectedCategory: Category

        func updateState(_ state: inout State) {

            state.moviesState.selectedCategory = selectedCategory
        }
    }

    struct ChangeViewModeAction: Action {

        func updateState(_ state: inout State) {

            state.moviesState.viewMode = state.moviesState.viewMode == .general ? .allCategories : .general
        }
    }

    struct AppendNowPlayingMoviesAction: Action {

        var movies: [ServerModels.Movie]

        func updateState(_ state: inout State) {

            state.moviesState.isNowPlayingLoading = false
            state.moviesState.nowPlayingPage += 1
            state.moviesState.nowPlayingMovies.append(contentsOf: movies)
        }
    }

    struct AppendUpcomingMoviesAction: Action {

        var movies: [ServerModels.Movie]

        func updateState(_ state: inout State) {

            state.moviesState.isUpcomingLoading = false
            state.moviesState.upcomingPage += 1
            state.moviesState.upcomingMovies.append(contentsOf: movies)
        }
    }

    struct AppendTrendingMoviesAction: Action {

        var movies: [ServerModels.Movie]

        func updateState(_ state: inout State) {

            state.moviesState.isTrendingLoading = false
            state.moviesState.trendingPage += 1
            state.moviesState.trendingMovies.append(contentsOf: movies)
        }
    }

    struct AppendPopularMoviesAction: Action {

        var movies: [ServerModels.Movie]

        func updateState(_ state: inout State) {

            state.moviesState.isPopularLoading = false
            state.moviesState.popularPage += 1
            state.moviesState.popularMovies.append(contentsOf: movies)
        }
    }
}
