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

    var selectedCategory = Category.nowPlaying

    enum ViewMode {
        case general
        case allCategories
    }
    var viewMode = ViewMode.general

    var nowPlayingPage: Int = 0
    var nowPlayingMovies = [Movie]()
    var loadNowPlayingMoviesState = LoadMovies.none

    var upcomingPage: Int = 0
    var upcomingMovies = [Movie]()
    var loadUpcomingMoviesState = LoadMovies.none

    var trendingPage: Int = 0
    var trendingMovies = [Movie]()
    var loadTrendingMoviesState = LoadMovies.none

    var popularPage: Int = 0
    var popularMovies = [Movie]()
    var loadPopularMoviesState = LoadMovies.none

    var selectedCategoryMovies: [Movie] {
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

}
