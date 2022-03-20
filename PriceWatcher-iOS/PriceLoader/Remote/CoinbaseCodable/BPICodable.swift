//
//  BPICodable.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

//
//    CodableBpiRoot.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CodableBpi : Codable {
    let eur : CodableCurrency?
    let gbp : CodableCurrency?
    let usd : CodableCurrency?

    enum CodingKeys: String, CodingKey {
        case eur = "EUR"
        case gbp = "GBP"
        case usd = "USD"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        eur = try values.decodeIfPresent(CodableCurrency.self, forKey: .eur)
        gbp = try values.decodeIfPresent(CodableCurrency.self, forKey: .gbp)
        usd = try values.decodeIfPresent(CodableCurrency.self, forKey: .usd)
    }
}
