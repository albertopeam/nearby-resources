//
//  MeepApiTests.swift
//  NearbyResourcesTests
//
//  Created by Alberto Penas Amor on 27/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import XCTest
import Combine
@testable import NearbyResources

class MeepApiTests: XCTestCase {

    private var sut: MeepApi!
    private var httpClientMock: HttpClientMock!
    private var subscriptions: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        httpClientMock = .init()
        sut = .init(httpClient: httpClientMock)
        subscriptions = .init()
    }

    override func tearDownWithError() throws {
        httpClientMock = nil
        sut = nil
        subscriptions = nil
        try super.tearDownWithError()
    }

    func testWhenGetResourcesThenMatchURL() throws {
        let subject = PassthroughSubject<(data: Data, response: URLResponse), URLError>()
        httpClientMock.publisher = subject.eraseToAnyPublisher()
        let bounds = LatLngBoundsBuilder()
            .northEast(.init(latitude: 1.1, longitude: 2.1))
            .southWest(.init(latitude: 3.2, longitude: 4.2))
            .build()

        _ = sut.resources(for: bounds)

        let url = try XCTUnwrap(httpClientMock.request.url).absoluteString
        let range = NSRange(location: 0, length: url.utf8.count)
        let regex = try NSRegularExpression(pattern: "https://.+/tripplan/api/v1/routers/lisboa/resources\\?lowerLeftLatLon=3.2,4.2&upperRightLatLon=1.1,2.1")
        XCTAssertNotNil(regex.firstMatch(in: url, options: [], range: range))
    }

    func testGivenJsonWhenGetResourcesThenMatchMapped() throws {
        let data = try Data(withFileName: "resources_response", type: "json", from: Bundle(for: MeepApiTests.self))
        let subject = CurrentValueSubject<(data: Data, response: URLResponse), URLError>((data, HTTPURLResponseOk()))
        httpClientMock.publisher = subject.eraseToAnyPublisher()

        let expectation = self.expectation(description: #function)
        var output: [Resource]?
        sut.resources(for: LatLngBoundsBuilder().build())
            .sink(receiveCompletion: { _ in XCTFail("Shouldn´t happen") },
                  receiveValue: { output = $0; expectation.fulfill() })
            .store(in: &subscriptions)
        wait(for: expectation)

        XCTAssertEqual(try XCTUnwrap(output).count, 1)
    }

    func testGivenInvalidJsonWhenGetResourcesThenMatchError() throws {
        let data = try Data(withFileName: "invalid_response", type: "json", from: Bundle(for: MeepApiTests.self))
        let subject = CurrentValueSubject<(data: Data, response: URLResponse), URLError>((data, HTTPURLResponseOk()))
        httpClientMock.publisher = subject.eraseToAnyPublisher()

        let expectation = self.expectation(description: #function)
        var output: Subscribers.Completion<Error>?
        sut.resources(for: LatLngBoundsBuilder().build())
            .sink(receiveCompletion: { output = $0; expectation.fulfill() },
                  receiveValue: { _ in XCTFail("Shouldn´t happen") })
            .store(in: &subscriptions)
        wait(for: expectation)

        XCTAssertNotNil(try XCTUnwrap(output))
    }
}

private class HttpClientMock: HttpClient {
    var publisher: AnyPublisher<(data: Data, response: URLResponse), URLError>!
    var request: URLRequest!
    func publisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        self.request = request
        return publisher
    }
}

private class HTTPURLResponseOk: HTTPURLResponse {
    init() {
        super.init(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
