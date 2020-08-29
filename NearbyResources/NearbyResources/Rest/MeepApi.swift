//
//  MeepAPI.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 25/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation
import Combine

struct MeepApi: ApiRest {
    private let apiUrl = "https://apidev.meep.me/tripplan/api/v1"
    private let httpClient: HttpClient

    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }

    func resources(for latLngBounds: LatLngBounds) -> AnyPublisher<[Resource], Error> {
        let url = "\(apiUrl)/routers/lisboa/resources?lowerLeftLatLon=\(latLngBounds.southWest.latitude),\(latLngBounds.southWest.longitude)&upperRightLatLon=\(latLngBounds.northEast.latitude),\(latLngBounds.northEast.longitude)"
        guard let resourcesUrl = URL(string: url) else {
            fatalError("Couldn't conver string to url \(url)")
        }
        return httpClient
            .publisher(for: URLRequest(url: resourcesUrl))
            .map(\.data)
            .decode(type: [CodableResource].self, decoder: JSONDecoder())
            .map({ NearbyResourcesMapper(resources: $0).map() })
            .eraseToAnyPublisher()
    }
}

private struct CodableResource: Decodable {
    let id: String
    let name: String
    let companyZoneId: Int
    let lat: Double?
    let lon: Double?
}

private struct NearbyResourcesMapper {
    let resources: [CodableResource]
    func map() -> [Resource] {
        return resources.compactMap({
            guard let lat = $0.lat, let lon = $0.lon else { return nil }
            return Resource(id: $0.id, name: $0.name, companyId: $0.companyZoneId, latLng: .init(latitude: lat, longitude: lon))
        })
    }
}
