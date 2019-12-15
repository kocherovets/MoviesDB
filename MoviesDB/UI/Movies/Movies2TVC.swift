//
//  MoviesTVC.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 25.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit

enum Movies2TVCModule {

    class DI: DIPart {
        static func load(container: DIContainer) {

            container.register(Movies2TVC.self)
                .injection(\Movies2TVC.presenter) { $0 as Presenter }
                .lifetime(.objectGraph)

            container.register (Presenter.init)
                .injection(cycle: true, \Presenter.propsReceiver)
                .lifetime(.objectGraph)
        }
    }

    class Presenter: PresenterBase<State, TableProps, Movies2TVC> {


        override func onInit(state: State, trunk: Trunk) {
            if state.moviesState.nowPlayingMovies.count == 0 {
                trunk.dispatch(MoviesState.LoadNowPlayingMoviesSE())
            }
            if state.moviesState.upcomingMovies.count == 0 {
                trunk.dispatch(MoviesState.LoadUpcomingMoviesSE())
            }
            if state.moviesState.trendingMovies.count == 0 {
                trunk.dispatch(MoviesState.LoadTrendingMoviesSE())
            }
            if state.moviesState.popularMovies.count == 0 {
                trunk.dispatch(MoviesState.LoadPopularMoviesSE())
            }
        }

        override func reaction(for box: StateBox<State>) -> ReactionToState {

            return .props
        }

        override func props(for box: StateBox<State>, trunk: Trunk) -> TableProps? {

            var rows = [CellAnyModel]()

            var items = [PosterCVCellVM]()
            if box.state.moviesState.nowPlayingMovies.count > 0 {
                let top = min(10, box.state.moviesState.nowPlayingMovies.count)
                items = box.state.moviesState.nowPlayingMovies[0 ..< top].map { PosterCVCellVM(posterPath: $0.posterPath) }
            } else {
                items = (1 ... 10).map { _ in PosterCVCellVM(posterPath: "") }
            }
            rows.append(CollectionCellVM(items: items))

            if box.state.moviesState.upcomingMovies.count > 0 {
                let top = min(10, box.state.moviesState.upcomingMovies.count)
                items = box.state.moviesState.upcomingMovies[0 ..< top].map { PosterCVCellVM(posterPath: $0.posterPath) }
            } else {
                items = (1 ... 10).map { _ in PosterCVCellVM(posterPath: "") }
            }
            rows.append(CollectionCellVM(items: items))

            if box.state.moviesState.trendingMovies.count > 0 {
                let top = min(10, box.state.moviesState.trendingMovies.count)
                items = box.state.moviesState.trendingMovies[0 ..< top].map { PosterCVCellVM(posterPath: $0.posterPath) }
            } else {
                items = (1 ... 10).map { _ in PosterCVCellVM(posterPath: "") }
            }
            rows.append(CollectionCellVM(items: items))

            if box.state.moviesState.popularMovies.count > 0 {
                let top = min(10, box.state.moviesState.popularMovies.count)
                items = box.state.moviesState.popularMovies[0 ..< top].map { PosterCVCellVM(posterPath: $0.posterPath) }
            } else {
                items = (1 ... 10).map { _ in PosterCVCellVM(posterPath: "") }
            }
            rows.append(CollectionCellVM(items: items))

            return TableProps(tableModel: TableModel(rows: rows))
        }
    }
}

class Movies2TVC: TVC<TableProps> {

}
