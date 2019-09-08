//
//  FindMobileDataUseCase.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 7/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation

protocol FindMobileDataUseCase {
    func execute(requestValue: FindMobileDataUseCaseRequestValue,
                 completion: @escaping (Result<MobileDataUsage, Error>) -> Void) -> Cancellable?
}

final class DefaultFindMobileDataUseCase: FindMobileDataUseCase {
    
    private let mobileDatasRepository: MobileDatasRepository
    
    init(mobileDatasRepository: MobileDatasRepository) {
        self.mobileDatasRepository = mobileDatasRepository
    }
    
    func execute(requestValue: FindMobileDataUseCaseRequestValue,
                 completion: @escaping (Result<MobileDataUsage, Error>) -> Void) -> Cancellable? {
        return mobileDatasRepository.mobileDatasList(limit: requestValue.limit, page: requestValue.page) { result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
}

struct FindMobileDataUseCaseRequestValue {
    let limit: Int
    let page: Int
}
