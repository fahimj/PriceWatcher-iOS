//
//  LocalLocation.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 20/03/22.
//

import Foundation

struct LocalLocation : Codable {
    let latitude:Double
    let longitude:Double
    
    var location: Location {
        Location(latitude: latitude, longitude: longitude)
    }
}
