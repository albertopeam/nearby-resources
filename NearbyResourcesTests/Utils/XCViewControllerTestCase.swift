//
//  XCViewControllerTestCase.swift
//  NearbyResourcesTests
//
//  Created by Alberto Penas Amor on 27/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import XCTest
@testable import NearbyResources

class XCViewControllerTestCase: XCTestCase {
    func loadViewController(_ viewController: UIViewController) throws {
        UIView.setAnimationsEnabled(false)
        let window = try currentWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        RunLoop.current.run(until: Date())
    }

    func unloadViewController() throws {
        let window = try currentWindow()
        window.rootViewController = nil
        UIView.setAnimationsEnabled(true)
    }

    // MARK: - helper
    
    @discardableResult
    func wait(function: String = #function, timeout seconds: TimeInterval = 1) -> XCTWaiter {
        let waiter = XCTWaiter()
        waiter.wait(for: [expectation(description: function)], timeout: seconds)
        return waiter
    }

    // MARK: - private

    private func currentWindow() throws -> UIWindow {
        let scene = UIApplication.shared.connectedScenes.first
        let delegate = try XCTUnwrap(XCTUnwrap(scene).delegate as? SceneDelegate)
        return try XCTUnwrap(delegate.window)
    }
}
