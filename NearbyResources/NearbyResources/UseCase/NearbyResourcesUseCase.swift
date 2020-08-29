//
//  NearbyResourcesUseCase.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 25/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation
import Combine

struct NearbyResourcesUseCase: NearbyUseCase {
    private let api: ApiRest

    init(api: ApiRest) {
        self.api = api
    }

    func resources(for latLngBounds: LatLngBounds) -> AnyPublisher<[Resource], NearbyError> {
        return api
            .resources(for: latLngBounds)
            .mapError({
                switch $0 {
                    case is URLError: return .data
                    case is DecodingError: return .data
                    default: return .unknown
                }
            })
            .eraseToAnyPublisher()
    }
}
