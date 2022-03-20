//
//  PriceLocal.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

struct LocalPrice : Codable {
    let pairName: String
    let value: Double
    let date: Date
    
    var price:Price {
        Price(pairName: pairName, value: value, date: date)
    }
}
