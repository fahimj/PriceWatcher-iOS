//
//  Price.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

struct Price {
    let pairName: String
    let price: Double
    let date: Date
}

struct Location {
    let latitude:Double
    let longitude:Double
}

struct PriceDataRequestActivity {
    let prices:[Price]
    let location:Location
    let date: Date
}
