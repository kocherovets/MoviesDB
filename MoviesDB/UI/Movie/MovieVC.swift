//
//  ViewController.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 10.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit

enum MovieVCModule {

    class DI: DIPart {
        static func load(container: DIContainer) {

            container.register(MovieVC.self)
                .injection(\MovieVC.presenter) { $0 as Presenter }
                .lifetime(.objectGraph)

            container.register (Presenter.init)
                .injection(cycle: true, \Presenter.propsReceiver)
                .lifetime(.objectGraph)
        }
    }

    struct Props: Properties, Equatable {
    }

    class Presenter: PresenterBase<State, Props, MovieVC> {

        private var movieModuleId = UUID().uuidString
        var movieId: Int!
        private var uuid = UUID().uuidString

        override func onInit(state: State, trunk: Trunk) {

            trunk.dispatch(MovieState.CreateDetailsSE(uuid: uuid, movieId: movieId))
        }

        override func onDeinit(state: State, trunk: Trunk) {

            trunk.dispatch(MovieState.RemoveDetailsAction(uuid: uuid))
        }

        override func reaction(for box: StateBox<State>) -> ReactionToState {
            return .props
        }

        override func props(for box: StateBox<State>, trunk: Trunk) -> Props? {

            return Props(
            )
        }
    }
}

class MovieVC: VC<MovieVCModule.Props> {

    var movieTitle: String!

    @IBOutlet fileprivate weak var containerView1: UIView!

//    private weak var tableVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = movieTitle
    }

    override func render() {

        guard let props = props else { return }

    }
}
