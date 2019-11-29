//
//  State.swift
//  MoviesDB
//
//  Created by Dmitry Kocherovets on 25.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import Foundation
import RedSwift

struct State: RootStateType, Equatable {
    
    var moviesState = MoviesState()
}
