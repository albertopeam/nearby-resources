//
//  NearbyResourcesViewControllerTests.swift
//  NearbyResourcesTests
//
//  Created by Alberto Penas Amor on 27/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import XCTest
import Combine
@testable import NearbyResources

class NearbyResourcesViewControllerTests: XCViewControllerTestCase {

    private var viewModelMock: NearbyViewModelMock!
    private var sut: NearbyResourcesViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModelMock = .init()
        sut = NearbyResourcesViewController(viewModel: viewModelMock, camera: Constants.fallbackCamera)
        try loadViewController(sut)
    }

    override func tearDownWithError() throws {
        viewModelMock = nil
        sut = nil
        try unloadViewController()
        try super.tearDownWithError()
    }

    func testGivenViewDidLoadWhenNotReceiveDataYetThenMatchLoading() throws {
        wait()

        XCTAssertTrue(sut.nearbyView.activityIndicator.isAnimating)
        XCTAssertTrue(sut.nearbyView.snackBarView.isHidden)
    }

    func testGivenViewDidLoadWhenReceiveErrorThenMatchError() throws {
        viewModelMock.publisher.send(completion: .failure(.init(message: "Some Error")))

        wait()

        XCTAssertFalse(sut.nearbyView.activityIndicator.isAnimating)
        XCTAssertFalse(sut.nearbyView.snackBarView.isHidden)
    }

    func testGivenViewDidLoadWhenReceiveSuccessThenNotLoadingNorError() throws {
        wait()
        viewModelMock.publisher.send([.init(id: "1", name: "place", latLng: .init(latitude: 38.711046, longitude: -9.160096), hue: 0.5)])

        wait()

        XCTAssertFalse(sut.nearbyView.activityIndicator.isAnimating)
        XCTAssertTrue(sut.nearbyView.snackBarView.isHidden)
    }
}

private class NearbyViewModelMock: NearbyViewModel {
    var publisher: PassthroughSubject<[ResourceDecorator], ResourcesError> = .init()

    func resources(for latLngBounds: LatLngBounds) -> AnyPublisher<[ResourceDecorator], ResourcesError> {
        return publisher.eraseToAnyPublisher()
    }
}
