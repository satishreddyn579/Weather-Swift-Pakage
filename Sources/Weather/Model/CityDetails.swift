//
//  File.swift
//  
//
//  Created by Sateeshreddy N @ AGTSPL on 13/11/21.
//

import Foundation
// MARK: - CityDetail
class CityDetail: Codable {
    var title, locationType: String?
    var woeid: Int?
    var lattLong: String?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case locationType = "location_type"
        case woeid = "woeid"
        case lattLong = "latt_long"
    }

    init(title: String?, locationType: String?, woeid: Int?, lattLong: String?) {
        self.title = title
        self.locationType = locationType
        self.woeid = woeid
        self.lattLong = lattLong
    }
}

typealias CityDetails = [CityDetail]
