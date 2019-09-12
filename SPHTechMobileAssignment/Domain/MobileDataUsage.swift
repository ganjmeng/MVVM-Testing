//
//  MobileDataUsage.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 6/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
struct MobileDataUsage : Codable {
    let help : String?
    let success : Bool?
    var result : MobileDataResult?
    
    enum CodingKeys: String, CodingKey {
        
        case help = "help"
        case success = "success"
        case result = "result"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        help = try values.decodeIfPresent(String.self, forKey: .help)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        result = try values.decodeIfPresent(MobileDataResult.self, forKey: .result)
    }
    
}
