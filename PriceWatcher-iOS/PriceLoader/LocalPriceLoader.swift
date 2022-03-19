//
//  LocalPriceLoader.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

protocol PriceLoader {
    func load() async throws -> [Price]
}

protocol PriceCache {
    func save(price:[Price], longitude:Double, latitude:Double)
    func delete()
}

class LocalPriceLoader {
    
    func save(price:[Price], longitude:Double, latitude:Double) async throws {
        var existingPricesData = try! await self.load()
        existingPricesData.append(contentsOf: price)
        
        let localPrices = existingPricesData.map{item in
            LocalPrice(pairName: item.pairName, value: item.price, date: item.date)
        }
        
        let localLocation = LocalLocation(latitude: latitude, longitude: longitude)
        let localUserActivity = LocalDataRequestActivity(prices: localPrices, location: localLocation, date: Date())
        
        let encodedData = try JSONEncoder().encode(localUserActivity)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: "SavedItem")
    }
    
    func load() async throws -> [Price] {
        let userDefaults = UserDefaults.standard
        guard let dataJson = userDefaults.data(forKey: "SavedItem") else {return []}
        
        let localUserActivity = try JSONDecoder().decode(LocalDataRequestActivity.self, from: dataJson)
        let prices = localUserActivity.prices.map{item in
            Price(pairName: item.pairName, price: item.value, date: item.date)
        }
        return prices
    }

}
