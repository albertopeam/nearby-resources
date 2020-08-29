//
//  NearbyViewControllerFactory.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 25/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import UIKit

struct NearbyResourcesAssembler {
    static func assemble() -> UIViewController {
        let api = MeepApi(httpClient: HttpClientSession())
        let useCase = NearbyResourcesUseCase(api: api)
        let viewModel = NearbyResourcesViewModel(useCase: useCase)
        return NearbyResourcesViewController(viewModel: viewModel, camera: Constants.fallbackCamera)
    }
}
