//
//  Resource.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 25/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation

struct Resource: Equatable {
    let id: String
    let name: String
    let companyId: Int
    let latLng: LatLng
}
