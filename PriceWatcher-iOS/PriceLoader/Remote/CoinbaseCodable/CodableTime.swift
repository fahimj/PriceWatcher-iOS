//
//  CodableTime.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

struct CodableTime : Codable {
    let updated : String?
    let updatedISO : String?
    let updateduk : String?
    let updatedDate : Date?

    enum CodingKeys: String, CodingKey {
        case updated = "updated"
        case updatedISO = "updatedISO"
        case updateduk = "updateduk"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        updated = try values.decodeIfPresent(String.self, forKey: .updated)
        updatedISO = try values.decodeIfPresent(String.self, forKey: .updatedISO)
        updateduk = try values.decodeIfPresent(String.self, forKey: .updateduk)
        updatedDate = try values.decodeIfPresent(Date.self, forKey: .updatedISO)
    }
}
