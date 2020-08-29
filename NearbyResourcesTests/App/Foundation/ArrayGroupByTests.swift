//
//  ArrayGroupByTests.swift
//  NearbyResourcesTests
//
//  Created by Alberto Penas Amor on 27/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import XCTest
@testable import NearbyResources

class ArrayGroupByTests: XCTestCase {
    private struct Item: Equatable {
        let id: Int
    }

    func testGivenEmptyItemsWhenGroupByThenMatchEmptyDictionary() {
        let sut: [Item] = []

        let result = sut.group(by: { $0.id })

        XCTAssertTrue(result.isEmpty)
    }

    func testGivenOneItemWhenGroupByThenMatchDictionaryWithOneItem() throws {
        let sut: [Item] = [.init(id: 1)]

        let result = sut.group(by: { $0.id })

        XCTAssertEqual(result, [1:[Item(id: 1)]])
    }

    func testGivenTwoDifferentItemsWhenGroupByThenMatchDictionaryWithTwoItem() throws {
        let sut: [Item] = [.init(id: 2), .init(id: 1)]

        let result = sut.group(by: { $0.id })

        XCTAssertEqual(result, [2:[Item(id: 2)], 1:[Item(id: 1)]])
    }

    func testGivenThreeItemsTwoEqualAndOneWithDifferentWhenGroupByThenMatchDictionaryWithTwoItemsWithDiffLengths() throws {
        let sut: [Item] = [.init(id: 1), .init(id: 2), .init(id: 1)]

        let result = sut.group(by: { $0.id })

        XCTAssertEqual(result, [2:[Item(id: 2)], 1:[Item(id: 1), Item(id: 1)]])
    }

}
