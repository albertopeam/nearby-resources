//
//  XCTestCase+Utils.swift
//  NearbyResourcesTests
//
//  Created by Alberto Penas Amor on 28/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import XCTest

extension XCTestCase {
    func wait(for expectation: XCTestExpectation, timeout seconds: TimeInterval = 0.01) {
        wait(for: [expectation], timeout: seconds)
    }
}
