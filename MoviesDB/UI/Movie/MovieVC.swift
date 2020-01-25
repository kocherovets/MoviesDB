//
//  ViewController.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 10.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import UIKit

enum MovieVCModule {

    typealias ViewController = MovieVC

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

    struct Props: Properties, Equatable {
    }

    class Presenter: PresenterBase<State, Props, ViewController> {

        private var movieModuleId = UUID().uuidString
        var movieId: Int!
        private var uuid = UUID().uuidString

        override func onInit(state: State, trunk: Trunk) {

            trunk.dispatch(MovieState.CreateDetailsAction(uuid: uuid, movieId: movieId))
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

class MovieVC: VC, PropsReceiver {
    
    typealias Props = MovieVCModule.Props

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
