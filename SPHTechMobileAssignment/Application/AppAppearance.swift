//
//  AppAppearance.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 6/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
import  UIKit

final class AppAppearance {
    
    static func setupAppearance() {
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
