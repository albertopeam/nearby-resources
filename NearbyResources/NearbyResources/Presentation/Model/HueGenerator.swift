//
//  HueGenerator.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 28/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation

class HueGenerator {

    private var ids: [Int: Float] = [:]

    func newIds(for newIds: [Int]) {
        let newValues = newIds.map({ id in (id, Float.random(in: 0...1)) })
        let dictionary = Dictionary(uniqueKeysWithValues: newValues)
        ids.merge(dictionary, uniquingKeysWith: { (current, _) in current })
    }

    func hue(for id: Int) -> Float {
        ids[id] ?? 0
    }
}
