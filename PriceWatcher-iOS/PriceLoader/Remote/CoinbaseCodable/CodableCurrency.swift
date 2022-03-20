//
//  CodableCurrency.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

struct CodableCurrency : Codable {
    let code : String?
    let descriptionField : String?
    let rate : String?
    let rateFloat : Double?
    let symbol : String?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case descriptionField = "description"
        case rate = "rate"
        case rateFloat = "rate_float"
        case symbol = "symbol"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        rate = try values.decodeIfPresent(String.self, forKey: .rate)
        rateFloat = try values.decodeIfPresent(Double.self, forKey: .rateFloat)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
    }
}
