//
//  Data+FromFile.swift
//  NearbyResourcesTests
//
//  Created by Alberto Penas Amor on 29/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation
import XCTest

extension Data {
    init(withFileName name: String, type: String, from bundle: Bundle) throws {
        let path = try XCTUnwrap(bundle.path(forResource: name, ofType: type))
        self = try XCTUnwrap(NSData(contentsOfFile: path)) as Data
    }
}
