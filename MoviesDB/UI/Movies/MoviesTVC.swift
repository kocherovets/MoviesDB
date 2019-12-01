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

        override func initCommand() -> Command? {
            switch store.state.moviesState.selectedCategory {
            case .nowPlaing:
                if store.state.moviesState.nowPlaingMovies.count == 0 {
                    return Command { store.dispatch(MoviesState.LoadNowPlayingMoviesSE()) }
                }
            case .upcoming:
                if store.state.moviesState.upcomingMovies.count == 0 {
                    return Command { store.dispatch(MoviesState.LoadUpcomingMoviesSE()) }
                }
            case .trending:
                if store.state.moviesState.trendingMovies.count == 0 {
                    return Command { store.dispatch(MoviesState.LoadTrendingMoviesSE()) }
                }
            case .popular:
                if store.state.moviesState.popularMovies.count == 0 {
                    return Command { store.dispatch(MoviesState.LoadPopularMoviesSE()) }
                }
            }
            return nil
        }

        override func reaction(for box: StateBox<State>) -> ReactionToState {

            if !box.isNew(keyPath: \.moviesState.selectedCategoryMovies) {
                return .none
            }

            return .props
        }

        override func props(for box: StateBox<State>) -> TableProps? {

            var rows = [CellAnyModel]()

            rows.append(
                SegmentedCellVM(
                    selectedIndex: box.state.moviesState.selectedCategory.rawValue,
                    selectCommand: CommandWith<Int> { value in
                        let selectedCategory = MoviesState.Category(rawValue: value)!
                        store.dispatch(MoviesState.ChangeSelectedCategoryAction(selectedCategory: selectedCategory))
                        switch selectedCategory {
                        case .nowPlaing:
                            if box.state.moviesState.nowPlaingMovies.count == 0 {
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

                let items = box.state.moviesState.selectedCategoryMovies.map { PosterCVCellVM(posterPath: $0.posterPath) }
                rows.append(CollectionCellVM(items: items))

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
            return TableProps(tableModel: TableModel(rows: rows))
        }
    }
}

class MoviesTVC: TVC<TableProps, MoviesTVCModule.Presenter> {

    override func render() {

        if let props = props {
//            set(model: props.tableModel, animations: DeclarativeTVC.fadeAnimations)
            delay(0.3) {
                self.set(model: props.tableModel, animations: nil)
            }
        }
    }

}
