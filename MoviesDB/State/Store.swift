//
//  TestStore.swift
//  ReduxVM
//
//  Created by Dmitry Kocherovets on 10.11.2019.
//  Copyright © 2019 Dmitry Kocherovets. All rights reserved.
//

import RedSwift

func delay(_ delay: Double, closure: @escaping () -> ()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class DependencyContainer: SideEffectDependencyContainer {
    let api = UnauthorizedAPI.self
}

let storeQueue = DispatchQueue(label: "queueTitle", qos: .userInteractive)

var mainStore = Store<State>(state: State(),
                             queue: storeQueue,
                             sideEffectDependencyContainer: DependencyContainer(),
                             middleware: [])

