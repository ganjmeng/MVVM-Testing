//
//  MobileDatasRepositoryInterfaces.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 7/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
protocol MobileDatasRepository {
    @discardableResult
    func mobileDatasList(limit: Int, page: Int, completion: @escaping (Result<MobileDataUsage, Error>) -> Void) -> Cancellable?
}
