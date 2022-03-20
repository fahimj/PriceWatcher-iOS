//
//  LocalDataRequestActivity.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 20/03/22.
//

import Foundation

struct LocalDataRequestActivity : Codable {
    let prices:[LocalPrice]
    let location:LocalLocation
    let date: Date
    
    var userActivity:PriceDataRequestActivity {
        PriceDataRequestActivity(prices: prices.map{$0.price}, location: self.location.location, date: date)
    }
}
