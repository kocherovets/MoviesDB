//
//  MoviesTVC.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 25.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import Foundation

import UIKit
import ReduxVM
import DeclarativeTVC
import RedSwift

enum MoviesTVCModule {

    class Presenter: PresenterBase<TableProps, State> {

        override func onInit() {
            switch store.state.moviesState.selectedCategory {
            case .nowPlaying:
                if store.state.moviesState.nowPlayingMovies.count == 0 {
                    store.dispatch(MoviesState.LoadNowPlayingMoviesSE())
                }
            case .upcoming:
                if store.state.moviesState.upcomingMovies.count == 0 {
                    store.dispatch(MoviesState.LoadUpcomingMoviesSE())
                }
            case .trending:
                if store.state.moviesState.trendingMovies.count == 0 {
                    store.dispatch(MoviesState.LoadTrendingMoviesSE())
                }
            case .popular:
                if store.state.moviesState.popularMovies.count == 0 {
                    store.dispatch(MoviesState.LoadPopularMoviesSE())
                }
            }
        }

        override func reaction(for box: StateBox<State>) -> ReactionToState {

            if !box.isNew(keyPath: \.moviesState.selectedCategoryMovies) {
                return .none
            }

            return .props
        }

        override func propsWithDelay(for box: StateBox<State>) -> PropsWithDelay? {

            var rows = [CellAnyModel]()

            rows.append(
                SegmentedCellVM(
                    selectedIndex: box.state.moviesState.selectedCategory.rawValue,
                    selectCommand: CommandWith<Int> { value in
                        let selectedCategory = MoviesState.Category(rawValue: value)!
                        store.dispatch(MoviesState.ChangeSelectedCategoryAction(selectedCategory: selectedCategory))
                        switch selectedCategory {
                        case .nowPlaying:
                            if box.state.moviesState.nowPlayingMovies.count == 0 {
                                store.dispatch(MoviesState.LoadNowPlayingMoviesSE())
                            }
                        case .upcoming:
                            if box.state.moviesState.upcomingMovies.count == 0 {
                                store.dispatch(MoviesState.LoadUpcomingMoviesSE())
                            }
                        case .trending:
                            if box.state.moviesState.trendingMovies.count == 0 {
                                store.dispatch(MoviesState.LoadTrendingMoviesSE())
                            }
                        case .popular:
                            if box.state.moviesState.popularMovies.count == 0 {
                                store.dispatch(MoviesState.LoadPopularMoviesSE())
                            }
                        }
                    })
            )

            if box.state.moviesState.selectedCategoryMovies.count > 0 {

                for movie in box.state.moviesState.selectedCategoryMovies {
                    rows.append(
                        MovieCellVM(title: movie.title,
                                    overview: movie.overview,
                                    date: movie.releaseDate,
                                    votePercentage: movie.votePercentage,
                                    posterPath: movie.posterPath)
                    )
                }
            } else {
                for _ in 0 ..< 20 {
                    rows.append(
                        MovieStubCellVM()
                    )
                }
            }
            return PropsWithDelay(
                props: TableProps(tableModel: TableModel(rows: rows)),
                delay: box.isNew(keyPath: \.moviesState.selectedCategory) ? 0.3 : 0
            )
        }
    }
}

class MoviesTVC: TVC<TableProps, MoviesTVCModule.Presenter> {

    override func render() {

        if let props = props {
//            set(model: props.tableModel, animations: DeclarativeTVC.fadeAnimations)
            self.set(model: props.tableModel, animations: nil)
        }
    }

}
