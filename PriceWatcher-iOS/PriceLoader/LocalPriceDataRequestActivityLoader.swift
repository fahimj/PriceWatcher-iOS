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

protocol PriceDataRequestActivityCache {
    func loadCache() async throws -> [PriceDataRequestActivity]
    func save(price:[Price], longitude:Double, latitude:Double) async throws
    func delete()
}

class LocalPriceDataRequestActivityLoader : PriceDataRequestActivityCache {
    func delete() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: "SavedItem")
        userDefaults.synchronize()
    }
    
    func save(price:[Price], longitude:Double, latitude:Double) async throws {
        let existingData = try! await self.loadCache()
        
        var existingActivities = existingData.map{data  -> LocalDataRequestActivity in
            let localPrices = data.prices.map{LocalPrice(pairName: $0.pairName, value: $0.value, date: $0.date)}
            let localLocation = LocalLocation(latitude: data.location.latitude, longitude: data.location.longitude)
            return LocalDataRequestActivity(prices: localPrices, location: localLocation, date: data.date)
        }
        let localPrices = price.map{LocalPrice(pairName: $0.pairName, value: $0.value, date: $0.date)}
        let localLocation = LocalLocation(latitude: latitude, longitude: longitude)
        let newLocalUserActivity = LocalDataRequestActivity(prices: localPrices, location: localLocation, date: Date())
        
        existingActivities.append(newLocalUserActivity)
        
        let encodedData = try JSONEncoder().encode(existingActivities)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: "SavedItem")
    }
    
    func loadCache() async throws -> [PriceDataRequestActivity] {
        let userDefaults = UserDefaults.standard
        guard let dataJson = userDefaults.data(forKey: "SavedItem") else {return []}
        
        let localUserActivity = try JSONDecoder().decode([LocalDataRequestActivity].self, from: dataJson)
        return localUserActivity.map{$0.userActivity}
    }

}
