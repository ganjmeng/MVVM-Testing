//
//  MobileDataViewModel.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 7/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
let MOBILE_DATA_STORE_KEY = "mobileData"
let LIMIT: Int = 40

enum MobileDataListViewModelRoute {
    case initial
    case showAlert(item: DefaultMobileDataListItemViewModel)

}

enum MobileDataListViewModelLoading {
    case none
    case initial
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
    private var responseItems:[Records]=[Records]()
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
        responseItems.append(contentsOf: mobileData.result?.records ?? []);
        
        let disPlayItems = DisplayModel.filteringRecords(responseItems: responseItems)
        self.items.value = disPlayItems.map { DefaultMobileDataListItemViewModel(model: $0)};
    }
    
    private func resetPages() {
        currentPage = -1
        totalPageCount = 1
        responseItems.removeAll()
        if (items.value.count > 0){
            items.value.removeAll()
        }
    }
    
    private func load(limit: Int, loadingType: MobileDataListViewModelLoading) {
        self.loadingType.value = loadingType
        if NetworkingManager.isInterNetExist() == false {
            guard items.value.count == 0 else {
                
                self.loadingType.value = .none
                self.handle(error: "No Internet connection")
                return
            }
            
            self.handle(error: "No Internet connection")
            SPHCacheManager.sharedInstance.getObjectForKey(MOBILE_DATA_STORE_KEY) { [weak self](result : MobileDataUsage?) in
                guard let model = result else{
                    print("获取失败了")
                    return
                }
                self!.appendPage(mobileData: model)
            }
            
            self.loadingType.value = .none
            return
        }
        
        
        let mobileRequest = FindMobileDataUseCaseRequestValue(limit: limit, page: nextPage)
        dataLoadTask = findMobileDataUseCase.execute(requestValue: mobileRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let mobileData):
                
                //store first time data
                if(strongSelf.loadingType.value == .initial) {
                  SPHCacheManager.sharedInstance.setObject(mobileData, forKey: MOBILE_DATA_STORE_KEY)
                }
       
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    strongSelf.appendPage(mobileData: mobileData)
                    strongSelf.loadingType.value = .none
                }
            case .failure(let error):
                strongSelf.handle(error: error.localizedDescription)
                strongSelf.loadingType.value = .none
            }
        }
    }
    
    private func handle(error: String) {
        self.error.value = error
    }
    
    private func update(limit: Int) {
        resetPages()
        load(limit: LIMIT, loadingType: .initial)
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
        route.value = .showAlert(item: item)
    }
}

