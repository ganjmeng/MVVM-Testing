//
//  dependencyContainer.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 7/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
import UIKit

final class AppDIContainer {
    
    lazy var appConfigurations = AppConfigurations()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransfer = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfigurations.apiBaseURL)!)
        
        let apiDataNetwork = DefaultNetworkService(session: URLSession.shared,
                                                   config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()

    
    // Dependency of scenes
    func makeMobileDataSceneDIContainer() -> MobileDataSceneDIContainer {
        let dependencies = MobileDataSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return MobileDataSceneDIContainer(dependencies: dependencies)
    }
}
