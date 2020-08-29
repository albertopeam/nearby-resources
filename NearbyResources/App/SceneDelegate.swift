//
//  SceneDelegate.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 24/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            if isNotTestEnv {
                window.rootViewController = NearbyResourcesAssembler.assemble()
            } else {
                window.rootViewController = UIViewController()
            }
            self.window = window
            window.makeKeyAndVisible()
        }
    }

}

private extension SceneDelegate {
    private var isNotTestEnv: Bool { return NSClassFromString("XCTest") == nil }
}

