//
//  DisplayModel.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 8/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
class DisplayModel {
    var year: String?
    var total: Double?
    var records: [Records]?
    var isDecrease: Bool?
    
    init(year: String?, total: Double?, records: [Records]?, isDecrease:Bool?) {
        self.year = year
        self.total = total
        self.records = records
        self.isDecrease = isDecrease
    }
    
    class func getTableViewRecords(responseItems: [Records]?) -> [DisplayModel]  {
        // Filtering API DATA and converting for Tableview display
        var records: [String: [Records]] = [:]
        if let res = responseItems, let count = responseItems?.count, count > 0 {
            for item in res {
                if let y2 = item.quarter?.split(separator: "-")[0] {
                    let val = res.filter {
                        let y1 = $0.quarter?.split(separator: "-")[0]
                        return (y1 == y2)
                    }
                    records["\(y2)"] = val
                }
            }
        }
        
        var tableViewRecords: [DisplayModel] = []
        var year:String
        var isDecrease:Bool = false
        var tot: Double = 0.0
        var pVal:Double = 0.0
        for (k, vals) in records {
            year = k
            isDecrease = false
            tot = 0.0
            pVal = 0.0
            for val in vals {
                if let q = val.volume_of_mobile_data {
                    tot += Double(q)!
                    if Double(q)!   < pVal {
                        isDecrease = true
                    }
                    pVal = Double(q)!
                }
            }
            
            if tot != 0, let ye = Int(year),  ye > 2003{
                // Add new data record - to display in tableview
                tableViewRecords.append(DisplayModel.init(year: year, total: tot, records: vals, isDecrease: isDecrease))
            }
        }
        return tableViewRecords.sorted(by:{
            if let y1 = $0.year, let y2 = $1.year  {
                return y1 < y2
            }
            return true
        })
    }
}
