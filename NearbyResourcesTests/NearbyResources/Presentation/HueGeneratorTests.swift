//
//  HueGeneratorTests.swift
//  NearbyResourcesTests
//
//  Created by Alberto Penas Amor on 28/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import XCTest
@testable import NearbyResources

class HueGeneratorTests: XCTestCase {
    func testGivenNoIdsWhenGetHueThenMatchZero() throws {
        let sut = HueGenerator()

        let result = sut.hue(for: 1)

        XCTAssertEqual(result, 0)
    }

    func testGivenIdsWhenGetHueThenMatchBetweenZeroAndOne() throws {
        let sut = HueGenerator()

        sut.newIds(for: [534, 612])
        let result = sut.hue(for: 612)

        XCTAssertGreaterThanOrEqual(result, 0)
        XCTAssertLessThanOrEqual(result, 1)
    }

    func testGivenSettedIdsTwoTimesWhenGetHueTwiceThenMatchAsEqual() throws {
        let sut = HueGenerator()

        sut.newIds(for: [534, 612])
        let firstResult = sut.hue(for: 612)
        sut.newIds(for: [612, 321])
        let secondResult = sut.hue(for: 612)

        XCTAssertEqual(firstResult, secondResult)
    }
}
