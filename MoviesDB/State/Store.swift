//
//  TestStore.swift
//  ReduxVM
//
//  Created by Dmitry Kocherovets on 10.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import RedSwift

class DependencyContainer: SideEffectDependencyContainer {
    let api = UnauthorizedAPI.self
}

let storeQueue = DispatchQueue(label: "queueTitle", qos: .userInteractive)
