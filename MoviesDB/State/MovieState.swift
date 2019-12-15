//
//  MovieState.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 15.12.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import Foundation
import Moya

struct MovieState: StateType, Equatable {

    enum Category: Int {
        case details = 0
        case credits = 1
        case recommended = 2
        case similar = 3
        case review = 4
    }

    var movieId: Int = 0

    var isDetailsLoading = false
    var details: ServerModels.MovieDetails? = nil

    var isCreditsLoading = false
    var credits = [ServerModels.Movie]()

    var isRecommendedLoading = false

    var isSimilarLoading = false

    var isReviewLoading = false

    var isLoading: Bool {
        return isDetailsLoading || isCreditsLoading || isRecommendedLoading || isSimilarLoading || isReviewLoading
    }
}

extension MovieState {

    fileprivate struct CreateDetailsAction: Action {

        let uuid: String
        let movieId: Int

        func updateState(_ state: inout State) {

            state.movieStates[uuid] = MovieState()
            state.movieStates[uuid]?.movieId = movieId
        }
    }

    struct RemoveDetailsAction: Action {

        let uuid: String

        func updateState(_ state: inout State) {

            state.movieStates[uuid] = nil
        }
    }

    struct CreateDetailsSE: SideEffect {

        let uuid: String
        let movieId: Int

        func sideEffect(state: State, trunk: Trunk, dependencies: DependencyContainer) {

            guard state.movieStates[uuid] == nil else { return }

            trunk.dispatch(CreateDetailsAction(uuid: uuid, movieId: movieId))

            loadDetails(state: state, trunk: trunk, dependencies: dependencies)
        }

        private func loadDetails(state: State, trunk: Trunk, dependencies: DependencyContainer) {

            trunk.dispatch(LoadAction(category: .details, uuid: uuid))

            _ = dependencies.api.request(target: UnauthorizedAPI.movieDetail(movie: movieId))
            {
                (result: Result<ServerModels.MovieDetails, Error>) in

                switch result {
                case .success(let data):
                    trunk.dispatch(AppendDetailsAction(details: data, uuid: self.uuid))
                case .failure:
                    trunk.dispatch(ErrorLoadingAction(category: .details, uuid: self.uuid))
                }
            }
        }
        private func loadCredits(state: State, trunk: Trunk, dependencies: DependencyContainer) {

        }
        private func loadRecommended(state: State, trunk: Trunk, dependencies: DependencyContainer) {

        }
        private func loadSimilar(state: State, trunk: Trunk, dependencies: DependencyContainer) {

        }
        private func loadReview(state: State, trunk: Trunk, dependencies: DependencyContainer) {

        }
    }

    struct LoadAction: Action {

        let category: Category
        let uuid: String

        func updateState(_ state: inout State) {
            switch category {
            case .details:
                state.movieStates[uuid]?.isDetailsLoading = true
            case .credits:
                state.movieStates[uuid]?.isCreditsLoading = true
            case .recommended:
                state.movieStates[uuid]?.isRecommendedLoading = true
            case .similar:
                state.movieStates[uuid]?.isSimilarLoading = true
            case .review:
                state.movieStates[uuid]?.isReviewLoading = true
            }
        }
    }

    struct ErrorLoadingAction: Action {

        let category: Category
        let uuid: String

        func updateState(_ state: inout State) {
            switch category {
            case .details:
                state.movieStates[uuid]?.isDetailsLoading = false
            case .credits:
                state.movieStates[uuid]?.isCreditsLoading = false
            case .recommended:
                state.movieStates[uuid]?.isRecommendedLoading = false
            case .similar:
                state.movieStates[uuid]?.isSimilarLoading = false
            case .review:
                state.movieStates[uuid]?.isReviewLoading = false
            }
        }
    }

    fileprivate struct AppendDetailsAction: Action {

        var details: ServerModels.MovieDetails
        let uuid: String

        func updateState(_ state: inout State) {

            state.movieStates[uuid]?.isDetailsLoading = false
            state.movieStates[uuid]?.details = details
        }
    }
}
