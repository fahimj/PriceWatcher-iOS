//
//  DataRequestActivityManager.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

class DataRequestActivityManager {
    let loader:PriceLoader
    let cache:PriceDataRequestActivityCache
    let locationManager:LocationManager
    
    init(loader:PriceLoader, cache:PriceDataRequestActivityCache, locationManager: LocationManager) {
        self.loader = loader
        self.cache = cache
        self.locationManager = locationManager
    }
    
    func loadRemotelyAndCache() async throws {
        let prices = try await loader.load()
        let longitude = locationManager.location?.coordinate.longitude ?? 0.0
        let latitude = locationManager.location?.coordinate.latitude ?? 0.0
        try await cache.save(price: prices, longitude: longitude, latitude: latitude)
    }
    
    func loadCache() async throws -> [PriceDataRequestActivity] {
        return try await cache.loadCache()
    }
}
