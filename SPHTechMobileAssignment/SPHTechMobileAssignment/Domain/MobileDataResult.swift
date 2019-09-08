//
//  Result.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 5/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
struct MobileDataResult : Codable {
    let resource_id : String?
    let fields : [Fields]?
    let records : [Records]?
    let _links : Links?
    let limit : Int?
    let total : Int?
    let offset: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case resource_id = "resource_id"
        case fields = "fields"
        case records = "records"
        case _links = "_links"
        case limit = "limit"
        case total = "total"
        case offset = "offset"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resource_id = try values.decodeIfPresent(String.self, forKey: .resource_id)
        fields = try values.decodeIfPresent([Fields].self, forKey: .fields)
        records = try values.decodeIfPresent([Records].self, forKey: .records)
        _links = try values.decodeIfPresent(Links.self, forKey: ._links)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
    
}
