//
//  MoviesTVC.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 25.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit

enum MoviesTVCModule {

    typealias ViewController = MoviesTVC

    class DI: DIPart {
        static func load(container: DIContainer) {

            container.register(ViewController.self)
                .injection(\ViewController.presenter) { $0 as Presenter }
                .lifetime(.objectGraph)

            container.register (Presenter.init)
                .injection(cycle: true, \Presenter.propsReceiver)
                .lifetime(.objectGraph)
        }
    }

    class Presenter: PresenterBase<State, TableProps, ViewController> {

        override func onInit(state: State, trunk: Trunk) {

            switch state.moviesState.selectedCategory {
            case .nowPlaying:
                if state.moviesState.nowPlayingMovies.count == 0 {
                    trunk.dispatch(MoviesState.LoadNowPlayingMoviesSE())
                }
            case .upcoming:
                if state.moviesState.upcomingMovies.count == 0 {
                    trunk.dispatch(MoviesState.LoadUpcomingMoviesSE())
                }
            case .trending:
                if state.moviesState.trendingMovies.count == 0 {
                    trunk.dispatch(MoviesState.LoadTrendingMoviesSE())
                }
            case .popular:
                if state.moviesState.popularMovies.count == 0 {
                    trunk.dispatch(MoviesState.LoadPopularMoviesSE())
                }
            }
        }

        override func reaction(for box: StateBox<State>) -> ReactionToState {

            if !box.isNew(keyPath: \.moviesState.selectedCategoryMovies) {
                return .none
            }

            return .props
        }

        override func props(for box: StateBox<State>, trunk: Trunk) -> TableProps? {

            var rows = [CellAnyModel]()

            rows.append(
                SegmentedCellVM(
                    selectedIndex: box.state.moviesState.selectedCategory.rawValue,
                    selectCommand: CommandWith<Int> { value in
                        let selectedCategory = MoviesState.Category(rawValue: value)!
                        trunk.dispatch(MoviesState.ChangeSelectedCategoryAction(selectedCategory: selectedCategory))
                        switch selectedCategory {
                        case .nowPlaying:
                            if box.state.moviesState.nowPlayingMovies.count == 0 {
                                trunk.dispatch(MoviesState.LoadNowPlayingMoviesSE())
                            }
                        case .upcoming:
                            if box.state.moviesState.upcomingMovies.count == 0 {
                                trunk.dispatch(MoviesState.LoadUpcomingMoviesSE())
                            }
                        case .trending:
                            if box.state.moviesState.trendingMovies.count == 0 {
                                trunk.dispatch(MoviesState.LoadTrendingMoviesSE())
                            }
                        case .popular:
                            if box.state.moviesState.popularMovies.count == 0 {
                                trunk.dispatch(MoviesState.LoadPopularMoviesSE())
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
                                    posterPath: movie.posterPath,
                                    selectCommand: Command {
                                        
                                        Router.showMovie(movieId: movie.id, title: movie.title)
                                    })
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

class MoviesTVC: TVC, PropsReceiver {

    typealias Props = TableProps

}
