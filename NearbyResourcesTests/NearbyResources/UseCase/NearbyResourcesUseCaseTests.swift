//
//  NearbyResourcesUseCaseTests.swift
//  NearbyResourcesTests
//
//  Created by Alberto Penas Amor on 27/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import XCTest
import Combine
@testable import NearbyResources

class NearbyResourcesUseCaseTests: XCTestCase {

    private var sut: NearbyResourcesUseCase!
    private var apiRestMock: ApiRestMock!
    private var subscriptions: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        apiRestMock = .init()
        sut = .init(api: apiRestMock)
        subscriptions = .init()
    }

    override func tearDownWithError() throws {
        apiRestMock = nil
        sut = nil
        subscriptions = nil
        try super.tearDownWithError()
    }

    func testGivenApiErrorWhenGetResourcesThenMatchOutputError() throws {
        struct Test {
            let error: Error
            let output: NearbyError
        }
        let items: [Test] = [
            .init(error: URLError(.badURL), output: .data),
            .init(error: DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "")), output: .data),
            .init(error: EncodingError.invalidValue(String(), .init(codingPath: [], debugDescription: "")), output: .unknown)
        ]
        items.forEach { (item) in
            let subject = PassthroughSubject<[Resource], Error>()
            apiRestMock.publisher = subject.eraseToAnyPublisher()
            subject.send(completion: .failure(item.error))
            let expectation = self.expectation(description: #function)

            var output: Subscribers.Completion<NearbyError>?
            sut.resources(for: LatLngBoundsBuilder().build())
                .sink(receiveCompletion: { output = $0; expectation.fulfill() },
                      receiveValue: { _ in XCTFail("Shouldn´t happen") })
                .store(in: &subscriptions)
            wait(for: expectation)

            XCTAssertEqual(output, Subscribers.Completion<NearbyError>.failure(item.output))
        }
    }

    func testGivenApiSuccessWhenGetResourcesThenMatchOutput() throws {
        apiRestMock.publisher = CurrentValueSubject([ResourceBuilder().build()]).eraseToAnyPublisher()
        let expectation = self.expectation(description: #function)

        var output: [Resource]?
        sut.resources(for: LatLngBoundsBuilder().build())
            .sink(receiveCompletion: { _ in XCTFail("Shouldn´t happen") },
                  receiveValue: { output = $0; expectation.fulfill() })
            .store(in: &subscriptions)
        wait(for: expectation)

        XCTAssertEqual(try XCTUnwrap(output), [ResourceBuilder().build()])
    }
}

private class ApiRestMock: ApiRest {
    var publisher: AnyPublisher<[Resource], Error>!
    func resources(for latLngBounds: LatLngBounds) -> AnyPublisher<[Resource], Error> {
        return publisher.eraseToAnyPublisher()
    }
}
