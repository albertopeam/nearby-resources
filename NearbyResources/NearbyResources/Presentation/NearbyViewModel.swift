//
//  NearbyViewModel.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 27/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation
import Combine

protocol NearbyViewModel {
    func resources(for latLngBounds: LatLngBounds) -> AnyPublisher<[ResourceDecorator], ResourcesError>
}
