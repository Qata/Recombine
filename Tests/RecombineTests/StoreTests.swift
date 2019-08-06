//
//  ObservableStoreTests.swift
//  Recombine
//
//  Created by Charlotte Tortorella on 2019-07-13.
//  Copyright © 2019 DigiTales. All rights reserved.
//

import XCTest
@testable import Recombine
import Combine

class ObservableStoreTests: XCTestCase {

    /**
     it deinitializes when no reference is held
     */
    func testDeinit() {
        var deInitCount = 0

        autoreleasepool {
            let store = DeInitStore(state: TestAppState(),
                                    reducer: testReducer,
                                    deInitAction: { deInitCount += 1 })
            Just(.int(100)).subscribe(store)
            XCTAssertEqual(store.state.testValue, 100)
        }

        XCTAssertEqual(deInitCount, 1)
    }
}

// Used for deinitialization test
class DeInitStore<State>: Store<State, SetAction> {
    var deInitAction: (() -> Void)?

    deinit {
        deInitAction?()
    }

    convenience init(state: State,
                     reducer: Reducer<State, SetAction>,
                     middleware: Middleware<State, SetAction> = Middleware(),
                     deInitAction: @escaping () -> Void) {
        self.init(state: state,
                  reducer: reducer,
                  middleware: middleware)
        self.deInitAction = deInitAction
    }
    
    required init(state: State,
                  reducer: Reducer<State, SetAction>,
                  middleware: Middleware<State, SetAction>) {
        super.init(state: state,
                   reducer: reducer,
                   middleware: middleware)
    }
}
