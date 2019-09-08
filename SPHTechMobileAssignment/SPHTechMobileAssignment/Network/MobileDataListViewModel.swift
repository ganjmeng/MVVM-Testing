//
//  MobileDataViewModel.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 7/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation

enum MobileDataListViewModelRoute {
    case initial
}

enum MobileDataListViewModelLoading {
    case none
    case fullScreen
    case nextPage
}

protocol MobileDataListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didLoad()
    func didSelect(item: DefaultMobileDataListItemViewModel)
}

protocol MobileDataListViewModelOutput {
    var route: Observable<MobileDataListViewModelRoute> { get }
    var items: Observable<[DefaultMobileDataListItemViewModel]> { get }
    var loadingType: Observable<MobileDataListViewModelLoading> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
}

protocol MobileDataListViewModel: MobileDataListViewModelInput, MobileDataListViewModelOutput {}

final class DefaultMobileDataListViewModel: MobileDataListViewModel {
    private let LIMIT: Int = 40
    private(set) var currentPage: Int = -1
    private var totalPageCount: Int = 1
    
    var hasMorePages: Bool {
        return currentPage < totalPageCount
    }
    var nextPage: Int {
        guard hasMorePages else { return currentPage }
        return currentPage + 1
    }
    
    private let findMobileDataUseCase: FindMobileDataUseCase
    private var dataLoadTask: Cancellable? { willSet { dataLoadTask?.cancel() } }
    
    // MARK: - OUTPUT
    let route: Observable<MobileDataListViewModelRoute> = Observable(.initial)
    let items: Observable<[DefaultMobileDataListItemViewModel]> = Observable([DefaultMobileDataListItemViewModel]())
    let loadingType: Observable<MobileDataListViewModelLoading> = Observable(.none)
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    
    @discardableResult
    init(findMobileDataUseCase: FindMobileDataUseCase) {
        self.findMobileDataUseCase = findMobileDataUseCase
    }
    
    private func appendPage(mobileData: MobileDataUsage) {
        self.currentPage = (mobileData.result?.offset)! / LIMIT
        self.totalPageCount = (mobileData.result?.total)! / LIMIT
        let disPlayItems = DisplayModel.getTableViewRecords(responseItems: mobileData.result?.records)
        self.items.value = items.value + disPlayItems.map { DefaultMobileDataListItemViewModel(model: $0)};
    }
    
    private func resetPages() {
        currentPage = -1
        totalPageCount = 1
        items.value.removeAll()
    }
    
    private func load(limit: Int, loadingType: MobileDataListViewModelLoading) {
        self.loadingType.value = loadingType
        
        let mobileRequest = FindMobileDataUseCaseRequestValue(limit: limit, page: nextPage)
        dataLoadTask = findMobileDataUseCase.execute(requestValue: mobileRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let mobileData):
                strongSelf.appendPage(mobileData: mobileData)
            case .failure(let error):
                strongSelf.handle(error: error)
            }
            strongSelf.loadingType.value = .none
        }
    }
    
    private func handle(error: Error) {
        self.error.value = "Failed loading data"
    }
    
    private func update(limit: Int) {
        resetPages()
        load(limit: LIMIT, loadingType: .fullScreen)
    }
}

// MARK: - INPUT. View event methods
extension DefaultMobileDataListViewModel {
    
    func viewDidLoad() {
        didLoad()
    }
    
    func didLoadNextPage() {
        guard hasMorePages, loadingType.value == .none else { return }
        load(limit: LIMIT,
             loadingType: .nextPage)
    }
    
    func didLoad() {
        update(limit: LIMIT)
    }
    
    
    func didSelect(item: DefaultMobileDataListItemViewModel) {

    }
}

