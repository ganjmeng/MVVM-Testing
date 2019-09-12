//
//  Records.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 5/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
struct Records : Codable {
    let volume_of_mobile_data : String?
    let quarter : String?
    let _id : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case volume_of_mobile_data = "volume_of_mobile_data"
        case quarter = "quarter"
        case _id = "_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        volume_of_mobile_data = try values.decodeIfPresent(String.self, forKey: .volume_of_mobile_data)
        quarter = try values.decodeIfPresent(String.self, forKey: .quarter)
        _id = try values.decodeIfPresent(Int.self, forKey: ._id)
    }
    
}
