//
//  MobileDataListItemViewModel.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 8/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation

protocol MobileDataListItemViewModelInput {
    func viewDidLoad()
}

protocol MobileDataListItemViewModelOutput {
    var year: String { get }
    var total: Double { get }
    var records: [Records] { get }
    var isDecrease: Bool{ get }
}

protocol MobileDataListItemViewModel: MobileDataListItemViewModelInput, MobileDataListItemViewModelOutput {}

final class DefaultMobileDataListItemViewModel: MobileDataListItemViewModel {
    
    // MARK: - OUTPUT
    let year: String
    let total: Double
    let records: [Records]
    var isDecrease: Bool

    init(model: DisplayModel) {
        self.year = model.year!
        self.total = model.total!
        self.records = model.records!
        self.isDecrease = model.isDecrease!
    }
}

// MARK: - INPUT. View event methods
extension DefaultMobileDataListItemViewModel {
    
    func viewDidLoad() {}
    
}


