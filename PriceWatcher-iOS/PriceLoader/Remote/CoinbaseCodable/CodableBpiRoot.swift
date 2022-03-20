//
//  CodableBpiRoot.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

struct CodableBpiRoot : Codable {
    let bpi : CodableBpi?
    let chartName : String?
    let disclaimer : String?
    let time : CodableTime?

    enum CodingKeys: String, CodingKey {
        case bpi
        case chartName = "chartName"
        case disclaimer = "disclaimer"
        case time
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bpi = try values.decodeIfPresent(CodableBpi.self, forKey: .bpi)
        chartName = try values.decodeIfPresent(String.self, forKey: .chartName)
        disclaimer = try values.decodeIfPresent(String.self, forKey: .disclaimer)
        time = try values.decodeIfPresent(CodableTime.self, forKey: .time)
    }
}
