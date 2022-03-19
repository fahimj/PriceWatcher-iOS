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
        Price(pairName: pairName, price: value, date: date)
    }
}

struct LocalLocation : Codable {
    let latitude:Double
    let longitude:Double
    
    var location: Location {
        Location(latitude: latitude, longitude: longitude)
    }
}

struct LocalUserActivity : Codable {
    let prices:[LocalPrice]
    let location:LocalLocation
    let date: Date
    
    var userActivity:UserActivity {
        UserActivity(prices: prices.map{$0.price}, location: self.location.location, date: date)
    }
}
