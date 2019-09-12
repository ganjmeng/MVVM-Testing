//
//  AppConfigurations.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 6/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
final class AppConfigurations {
    
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
//    lazy var imagesBaseURL: String = {
//        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
//            fatalError("ApiBaseURL must not be empty in plist")
//        }
//        return imageBaseURL
//    }()
}
