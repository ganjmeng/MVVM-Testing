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
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    var items: [DefaultMobileDataListItemViewModel]! {
        didSet { reload() }
    }
    final class func create(with viewModel: MobileDataListViewModel) -> MobileDataListViewController{
        let vc = MobileDataListViewController()
        vc.viewModel = viewModel
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mobile Data Usage"
        
        setupTableView()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: MobileDataListCell.reuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: MobileDataListCell.reuseIdentifier)
        tableView.estimatedRowHeight = MobileDataListCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView.init()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl(_:)), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.beginRefreshing()
    }
    
    func bind(to viewModel: MobileDataListViewModel) {
        viewModel.route.observe(on: self) { [weak self] route in
            self?.handle(route)
        }
        viewModel.items.observe(on: self) { [weak self] items in
            self?.items = items;
        }

        viewModel.error.observe(on: self) { [weak self] error in
            self?.showError(error)
        }
        viewModel.loadingType.observe(on: self) { [weak self] _ in
            self?.updateViewsVisibility(model: viewModel)
        }
    }
    
    func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: "Error", message: error)
    }
    
    private func updateViewsVisibility(model: MobileDataListViewModel?) {
        guard let model = model else { return }
       
        self.update(isLoadingNextPage: false)
        if model.loadingType.value == .initial {
            self.tableView.refreshControl?.beginRefreshing()
        } else if model.loadingType.value == .nextPage {
            self.update(isLoadingNextPage: true)
        } else if model.isEmpty {
            self.tableView.refreshControl?.endRefreshing()
        } else {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc fileprivate func handleRefreshControl(_ sender: UIRefreshControl) {
        viewModel.didLoad()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func update(isLoadingNextPage: Bool) {
        if isLoadingNextPage {
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = UIActivityIndicatorView(style: .gray)
            nextPageLoadingSpinner?.startAnimating()
            nextPageLoadingSpinner?.isHidden = false
            nextPageLoadingSpinner?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.frame.width, height: 44)
            tableView.tableFooterView = nextPageLoadingSpinner
        } else {
            tableView.tableFooterView = nil
        }
    }


}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MobileDataListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MobileDataListCell.reuseIdentifier, for: indexPath) as? MobileDataListCell else {
            fatalError("Cannot dequeue reusable cell \(MobileDataListCell.self) with reuseIdentifier: \(MobileDataListCell.reuseIdentifier)")
        }
        
        cell.fill(with: viewModel.items.value[indexPath.row])
        
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        cell.accessibilityLabel = String(format: "Result row %d", indexPath.row + 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        viewModel.didSelect(item: items[indexPath.row])
    }
}


// MARK: - Handle Routing

extension MobileDataListViewController {
    func handle(_ route: MobileDataListViewModelRoute) {
        switch route {
        case .initial: break
        case .showAlert(let item):
            
            let decre_strs = item.decreaseRecords.map({ "\(String(describing: $0.quarter!))" })
            let decreaseStr = decre_strs.joined(separator: "\n") + "📉🔻"
            
            let strs = item.records.map({ "\(String(describing: $0.quarter!))    \(String(describing: $0.volume_of_mobile_data!))" })
            let increaseStr = strs.joined(separator: "\n")
            
            showAlert(title: "\(item.year) Mobile data useage", message: item.isDecrease ? decreaseStr : increaseStr)

            break
        }
    }
}
