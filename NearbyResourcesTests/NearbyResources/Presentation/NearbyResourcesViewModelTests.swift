//
//  NearbyResourcesTests.swift
//  NearbyResourcesTests
//
//  Created by Alberto Penas Amor on 24/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import XCTest
import Combine
@testable import NearbyResources

class NearbyResourcesViewModelTests: XCTestCase {

    private var sut: NearbyResourcesViewModel!
    private var nearbyUseCaseMock: NearbyUseCaseMock!
    private var hueGeneratorSpy: HueGeneratorSpy!
    private var subscriptions: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        nearbyUseCaseMock = .init()
        hueGeneratorSpy = .init()
        sut = .init(useCase: nearbyUseCaseMock, hueGenerator: hueGeneratorSpy)
        subscriptions = .init()
    }

    override func tearDownWithError() throws {
        nearbyUseCaseMock = nil
        hueGeneratorSpy = nil
        sut = nil
        subscriptions = nil
        try super.tearDownWithError()
    }

    func testGivenUseCaseWillThrowErrorWhenGetResourcesThenMatchErrorString() throws {
        [NearbyError.data, NearbyError.unknown].forEach { (error) in
            let subject = PassthroughSubject<[Resource], NearbyError>()
            subject.send(completion: .failure(error))
            nearbyUseCaseMock.publisher = subject.eraseToAnyPublisher()

            let expectation = self.expectation(description: #function)
            var output: Subscribers.Completion<ResourcesError>?
            sut.resources(for: LatLngBoundsBuilder().build())
                .sink(receiveCompletion: { output = $0; expectation.fulfill() },
                      receiveValue: { _ in XCTFail("Shouldn´t happen") })
                .store(in: &subscriptions)
            wait(for: expectation)

            XCTAssertEqual(output, .failure(ResourcesError(message: NSLocalizedString("api_error", comment: ""))))
        }
    }

    func testGivenUseCaseWillReturnEmptyWhenGetResourcesThenMatchErrorString() throws {
        let subject = CurrentValueSubject<[Resource], NearbyError>([])
        nearbyUseCaseMock.publisher = subject.eraseToAnyPublisher()

        let expectation = self.expectation(description: #function)
        var output: Subscribers.Completion<ResourcesError>?
        sut.resources(for: LatLngBoundsBuilder().build())
            .sink(receiveCompletion: { output = $0; expectation.fulfill() },
                  receiveValue: { _ in XCTFail("Shouldn´t happen") })
            .store(in: &subscriptions)
        wait(for: expectation)

        XCTAssertEqual(output, .failure(ResourcesError(message: NSLocalizedString("empty_result", comment: ""))))
    }

    func testGivenUseCaseWillReturnResourcesWhenGetResourcesThenMatchErrorString() throws {
        let hue: Float = 0.2
        let resource = ResourceBuilder().build()
        let subject = CurrentValueSubject<[Resource], NearbyError>([resource])
        nearbyUseCaseMock.publisher = subject.eraseToAnyPublisher()
        hueGeneratorSpy.hueMock = hue

        let expectation = self.expectation(description: #function)
        var output: [ResourceDecorator]?
        sut.resources(for: LatLngBoundsBuilder().build())
            .sink(receiveCompletion: { _ in XCTFail("Shouldn´t happen") },
                  receiveValue: { output = $0; expectation.fulfill() })
            .store(in: &subscriptions)
        wait(for: expectation)

        XCTAssertEqual(output, [ResourceDecorator(id: resource.id, name: resource.name, latLng: resource.latLng, hue: hue)])
        XCTAssertEqual(hueGeneratorSpy.newIdsTimes, 1)
        XCTAssertEqual(hueGeneratorSpy.newIds, [resource.companyId])
        XCTAssertEqual(hueGeneratorSpy.hueTimes, 1)
    }
}

private class NearbyUseCaseMock: NearbyUseCase {
    var publisher: AnyPublisher<[Resource], NearbyError>!
    func resources(for latLngBounds: LatLngBounds) -> AnyPublisher<[Resource], NearbyError> {
        return publisher
    }


}

private class HueGeneratorSpy: HueGenerator {
    var newIdsTimes: Int = 0
    var newIds: [Int] = []
    var hueTimes: Int = 0
    var hueMock: Float = 0.5

    override func newIds(for newIds: [Int]) {
        newIdsTimes += 1
        self.newIds = newIds
    }
    override func hue(for id: Int) -> Float {
        hueTimes += 1
        return hueMock
    }
}
