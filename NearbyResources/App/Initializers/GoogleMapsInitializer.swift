//
//  GoogleMapsInitializer.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 25/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import GoogleMaps

struct GoogleMapsInitializer: Initializable {
    private let googleApiKey = "AIzaSyAednJohfRQAZ9GVvDI4f9V6SEZbvTb7fE"

    func initialize() {
         GMSServices.provideAPIKey(googleApiKey)
    }
}
