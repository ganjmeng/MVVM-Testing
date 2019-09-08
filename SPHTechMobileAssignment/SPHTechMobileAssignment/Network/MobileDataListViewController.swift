//
//  MobileDataListViewController.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 7/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import UIKit

class MobileDataListViewController: UITableViewController, Alertable {
    private(set) var viewModel: MobileDataListViewModel!
    final class func create(with viewModel: MobileDataListViewModel) -> MobileDataListViewController{
        let vc = MobileDataListViewController()
        vc.viewModel = viewModel
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mobile Data List"
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    
    func bind(to viewModel: MobileDataListViewModel) {
        viewModel.route.observe(on: self) { [weak self] route in
            self?.handle(route)
        }
        viewModel.items.observe(on: self) { [weak self] items in
            print("items====", viewModel.items);
        }

        viewModel.error.observe(on: self) { [weak self] error in
            self?.showError(error)
        }
        viewModel.loadingType.observe(on: self) { [weak self] _ in
        }
    }
    
    func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: "Error", message: error)
    }


}

// MARK: - Handle Routing

extension MobileDataListViewController {
    func handle(_ route: MobileDataListViewModelRoute) {
        switch route {
        case .initial: break
        }
    }
}
