//
//  NetworkSessionMock.swift
//  SPHTechMobileAssignmentTests
//
//  Created by Jingmeng.Gan on 8/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
import SPHTechMobileAssignment

struct NetworkSessionMock: NetworkSession {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func loadData(from request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable {
        completionHandler(data, response, error)
        return URLSessionDataTask()
    }
}
