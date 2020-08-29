//
//  NearbyResourcesViewModel.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 25/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation
import Combine

struct NearbyResourcesViewModel: NearbyViewModel {
    private let useCase: NearbyUseCase
    private let hueGenerator: HueGenerator
    private var ids: [Int: Float] = [:]

    init(useCase: NearbyUseCase, hueGenerator: HueGenerator = .init()) {
        self.useCase = useCase
        self.hueGenerator = hueGenerator
    }

    func resources(for latLngBounds: LatLngBounds) -> AnyPublisher<[ResourceDecorator], ResourcesError>  {
        return useCase
            .resources(for: latLngBounds)
            .receive(on: RunLoop.main)
            .tryMap({ output -> [Int:[Resource]] in
                if output.isEmpty {
                    throw Error.empty
                }
                return output.group(by: { $0.companyId })
            })
            .handleEvents(receiveOutput: { output in
                self.hueGenerator.newIds(for: Array(output.keys))
            })
            .map({ resources in
                resources.flatMap({ item -> [ResourceDecorator] in
                    item.value.map({
                        ResourceDecorator(id: $0.id, name: $0.name, latLng: $0.latLng, hue: self.hueGenerator.hue(for: $0.companyId))
                    })
                })
            }).mapError({ error in
                if error is Error {
                    return ResourcesError(message: NSLocalizedString("empty_result", comment: ""))
                } else {
                    return ResourcesError(message: NSLocalizedString("api_error", comment: ""))
                }
            }).eraseToAnyPublisher()
    }
}

private extension NearbyResourcesViewModel {
    enum Error: Swift.Error {
        case empty
    }
}
