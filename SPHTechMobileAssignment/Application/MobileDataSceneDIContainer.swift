//
//  MobileDataSceneDIContainer.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 7/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//
import UIKit

final class MobileDataSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransfer
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeFindMobileDataUseCase() -> FindMobileDataUseCase {
        return DefaultFindMobileDataUseCase(mobileDatasRepository: makeMobileDatasRepository())
    }
    
    
    // MARK: - Repositories
    func makeMobileDatasRepository() -> MobileDatasRepository {
        return DefaultMobileDatasRepository(dataTransferService: dependencies.apiDataTransferService)
    }
  
    
    // MARK: - Mobile Data List
    func makeMobileDataListViewController() -> UIViewController {
        return MobileDataListViewController.create(with: makeMobileDataViewModel())
    }
    
    func makeMobileDataViewModel() -> MobileDataListViewModel {
        return DefaultMobileDataListViewModel(findMobileDataUseCase: makeFindMobileDataUseCase())
    }
    
}

