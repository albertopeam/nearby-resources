//
//  HttpClient.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 29/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation
import Combine

protocol HttpClient {
    func publisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}
