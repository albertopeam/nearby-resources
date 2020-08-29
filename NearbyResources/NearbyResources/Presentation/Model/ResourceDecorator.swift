//
//  ResourceDecorator.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 27/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation

struct ResourceDecorator: Equatable {
    let id: String
    let name: String
    let latLng: LatLng
    let hue: Float
}
