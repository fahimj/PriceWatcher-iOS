//
//  JsonDtoMapper.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

struct JsonDtoMapper {
    enum JsonMapperError: Error {
        case invalidJson
    }
    
    func mapToPrice(jsonData:Data) throws -> [Price] {
        let decoder = JSONDecoder()
        let json = try decoder.decode(CodableBpiRoot.self, from: jsonData)
        guard let bpis = json.bpi else {throw JsonMapperError.invalidJson }
        
        let dtos = [bpis.eur!, bpis.gbp!, bpis.usd!]
        let items = dtos.map{bpi in
            Price(pairName: "BTC" + bpi.code!, price: bpi.rateFloat!, date: Date())
        }
        return items
    }
}
