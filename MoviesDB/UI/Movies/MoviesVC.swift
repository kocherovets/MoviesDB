//
//  ViewController.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 10.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit
import ReduxVM
import DeclarativeTVC
import RedSwift

enum MoviesVCModule {

    struct Props: Properties, Equatable {
        let title: String
    }

    class Presenter: PresenterBase<Props, State> {

        override func reaction(for box: StateBox<State>) -> ReactionToState {
            return .props
        }

        override func props(for box: StateBox<State>) -> Props? {

            let title: String
            switch box.state.moviesState.selectedCategory {
            case .nowPlaing:
                title = "Now Plaing"
            case .upcoming:
                title = "Upcoming"
            case .trending:
                title = "Trending"
            case .popular:
                title = "Popular"
            }

            return Props(
                title: title
            )
        }
    }
}

class MoviesVC: VC<MoviesVCModule.Props, MoviesVCModule.Presenter> {

    override func viewDidLoad() {
        super.viewDidLoad()

        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
    }

    override func render() {

        guard let props = props else { return }
        
        navigationItem.title = props.title
    }
}

extension MoviesVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

    }
}
