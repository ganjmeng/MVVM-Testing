//
//  APIEndpoints.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 7/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation

struct APIEndpoints {
    
    static func mobileDatas(limit: Int, page: Int) -> DataEndpoint<MobileDataUsage> {
        
        return DataEndpoint(path: "api/action/datastore_search",
                            queryParameters: ["resource_id":"a807b7ab-6cad-4aa6-87d0-e283a7353a0f",
                                              "limit": limit,
                                              "offset": "\(page*limit)"])
    }
    
}
