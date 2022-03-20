//
//  LocalPriceLoader.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

protocol PriceSeriesLoader {
    func load(pair:String) async throws -> [Price]
}

class LocalPriceSeriesLoader : PriceSeriesLoader {
    func load(pair pairName:String) async throws -> [Price] {
        let userDefaults = UserDefaults.standard
        guard let dataJson = userDefaults.data(forKey: "SavedItem") else {return []}
        
        let localUserActivity = try JSONDecoder().decode([LocalDataRequestActivity].self, from: dataJson)
        return localUserActivity.flatMap{$0.userActivity.prices}
            .filter{$0.pairName == pairName}
            .sorted(by: {$0.date < $1.date})
    }
}
