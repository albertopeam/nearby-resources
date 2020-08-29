//
//  LatLngBoundsBuilder.swift
//  NearbyResourcesTests
//
//  Created by Alberto Penas Amor on 28/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation
@testable import NearbyResources

class LatLngBoundsBuilder {
    private var northEast: LatLng = .init(latitude: 38, longitude: -9)
    private var southWest: LatLng = .init(latitude: 39, longitude: -10)

    func northEast(_ param: LatLng) -> Self {
        northEast = param
        return self
    }

    func southWest(_ param: LatLng) -> Self {
        southWest = param
        return self
    }

    func build() -> LatLngBounds {
        .init(northEast: northEast, southWest: southWest)
    }
}
