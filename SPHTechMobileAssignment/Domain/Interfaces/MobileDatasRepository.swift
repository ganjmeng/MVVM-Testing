//
//  MobileDatasRepository.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 7/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation

final class DefaultMobileDatasRepository {
    
    private let dataTransferService: DataTransfer
    
    init(dataTransferService: DataTransfer) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultMobileDatasRepository: MobileDatasRepository {
    
    public func mobileDatasList(limit: Int, page: Int, completion: @escaping (Result<MobileDataUsage, Error>) -> Void) -> Cancellable? {
        
        let endpoint = APIEndpoints.mobileDatas(limit: limit, page: page)
        return self.dataTransferService.request(with: endpoint) { (response: Result<MobileDataUsage, Error>) in
            switch response {
            case .success(let mobileData):
                completion(.success(mobileData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
