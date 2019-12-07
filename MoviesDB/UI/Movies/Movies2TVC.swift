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

enum Movies2TVCModule {

    class Presenter: PresenterBase<TableProps, State> {

        override var store: Store<State>! {
            return mainStore
        }

        override func onInit() {
            if store.state.moviesState.nowPlayingMovies.count == 0 {
                store.dispatch(MoviesState.LoadNowPlayingMoviesSE())
            }
            if store.state.moviesState.upcomingMovies.count == 0 {
                store.dispatch(MoviesState.LoadUpcomingMoviesSE())
            }
            if store.state.moviesState.trendingMovies.count == 0 {
                store.dispatch(MoviesState.LoadTrendingMoviesSE())
            }
            if store.state.moviesState.popularMovies.count == 0 {
                store.dispatch(MoviesState.LoadPopularMoviesSE())
            }
        }

        override func reaction(for box: StateBox<State>) -> ReactionToState {

            return .props
        }

        override func props(for box: StateBox<State>) -> TableProps? {

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

class Movies2TVC: TVC<TableProps, Movies2TVCModule.Presenter> {

}
