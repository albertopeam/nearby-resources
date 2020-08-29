//
//  Array+GroupBy.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 25/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation


extension Array {
    func group<G: Hashable>(by closure: (Element) -> G) -> [G: [Element]] {
        var groups = [G: [Element]]()

        for element in self {
            let key = closure(element)
            var array = [Element]()

            for group in groups {
                let firstKey = group.key
                if firstKey == key {
                    array = group.value
                    break
                }
            }

            array.append(element)
            groups[key] = array
        }

        return groups
    }
}
