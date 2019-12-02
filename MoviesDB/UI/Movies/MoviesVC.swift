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
        let showsGeneralView: Bool
        let changeViewModeCommand: Command
    }

    class Presenter: PresenterBase<Props, State> {

        override func reaction(for box: StateBox<State>) -> ReactionToState {
            return .props
        }

        override func propsWithDelay(for box: StateBox<State>) -> PropsWithDelay? {

            let title: String
            if box.state.moviesState.viewMode == .general {
                switch box.state.moviesState.selectedCategory {
                case .nowPlaying:
                    title = "Now Plaing"
                case .upcoming:
                    title = "Upcoming"
                case .trending:
                    title = "Trending"
                case .popular:
                    title = "Popular"
                }
            } else {
                title = "Movies"
            }

            return PropsWithDelay(props:
                Props(
                    title: title,
                    showsGeneralView: box.state.moviesState.viewMode == .general,
                    changeViewModeCommand: Command { store.dispatch(MoviesState.ChangeViewModeAction()) }
                )
            )
        }
    }
}

class MoviesVC: VC<MoviesVCModule.Props, MoviesVCModule.Presenter> {

    @IBOutlet fileprivate weak var containerView1: UIView!
    @IBOutlet fileprivate weak var containerView2: UIView!

    private weak var tableVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
    }

    override func render() {

        guard let props = props else { return }

        navigationItem.title = props.title

        if props.showsGeneralView && containerView1.isHidden {
            setupTables(showsGeneralView: true)
        } else if !props.showsGeneralView && containerView2.isHidden {
            setupTables(showsGeneralView: false)
        }
    }

    @IBAction func changeMode() {
        props?.changeViewModeCommand.perform()
    }

    private func setupTables(showsGeneralView: Bool) {

        containerView1.isHidden = !showsGeneralView
        containerView2.isHidden = showsGeneralView
        containerView1.removeFromSuperview()
        containerView2.removeFromSuperview()

        if showsGeneralView {
            view.addSubview(containerView1)
            containerView1.pinEdges(to: view)
        } else {
            view.addSubview(containerView2)
            containerView2.pinEdges(to: view)
        }
    }
}

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}

extension MoviesVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

    }
}
