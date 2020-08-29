//
//  ResourceBuilder.swift
//  NearbyResourcesTests
//
//  Created by Alberto Penas Amor on 28/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation
@testable import NearbyResources

class ResourceBuilder {
    func build() -> Resource {
        .init(id: "1", name: "", companyId: 1, latLng: .init(latitude: 0, longitude: 0))
    }
}
