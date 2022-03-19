//
//  PriceLocal.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

struct LocalPrice : Codable {
    let pairName: String
    let price: Double
    let date: Date
}

struct LocalLocation : Codable {
    let latitude:Double
    let longitude:Double
}

struct LocalUserActivity : Codable {
    let prices:[LocalPrice]
    let location:LocalLocation
    let date: Date
}
