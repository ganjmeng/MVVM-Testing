//
//  NetworkingManager.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 8/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation

class NetworkingManager: NSObject {
    
    var reachability: Reachability!
    static let sharedInstance: NetworkingManager = {
        return NetworkingManager()
    }()
    
    override init() {
        super.init()
        reachability = Reachability()!
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        do {
            // Start notifier
            try reachability.startNotifier()
        } catch {
            print("监听网络失败")
        }
    }
    
    static func stopNotifier() -> Void {
        do {
            try (NetworkingManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("停止监听失败")
        }
    }
    
    // Network is reachable
    static func isInterNetExist() -> Bool {
        if (NetworkingManager.sharedInstance.reachability).isReachable {
            print("网络连接：可用")
            return true
        } else {
            print("网络连接：不可用")
            return false
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // networkStatusChanged!
    }

}
