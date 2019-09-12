//
//  MobileDataListViewModelTests.swift
//  SPHTechMobileAssignmentTests
//
//  Created by Jingmeng.Gan on 8/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
@testable import SPHTechMobileAssignment
import XCTest

class MobileDataListViewModelTests: XCTestCase {
    
    static var mobileDataUsage: MobileDataUsage = {
        let jsonString = """
            {
                "help": "https://data.gov.sg/api/3/action/help_show?name=datastore_search",
                "success": true,
                "result": {
                    "resource_id": "a807b7ab-6cad-4aa6-87d0-e283a7353a0f",
                    "fields": [{
                        "type": "int4",
                        "id": "_id"
                    }, {
                        "type": "text",
                        "id": "quarter"
                    }, {
                        "type": "numeric",
                        "id": "volume_of_mobile_data"
                    }],
                    "records": [{
                        "volume_of_mobile_data": "0.000384",
                        "quarter": "2004-Q3",
                        "_id": 1
                    }, {
                        "volume_of_mobile_data": "0.000543",
                        "quarter": "2004-Q4",
                        "_id": 2
                    }, {
                        "volume_of_mobile_data": "0.00062",
                        "quarter": "2005-Q1",
                        "_id": 3
                    }, {
                        "volume_of_mobile_data": "0.000634",
                        "quarter": "2005-Q2",
                        "_id": 4
                    }, {
                        "volume_of_mobile_data": "0.000718",
                        "quarter": "2005-Q3",
                        "_id": 5
                    }, {
                        "volume_of_mobile_data": "0.000801",
                        "quarter": "2005-Q4",
                        "_id": 6
                    }, {
                        "volume_of_mobile_data": "0.00089",
                        "quarter": "2006-Q1",
                        "_id": 7
                    }, {
                        "volume_of_mobile_data": "0.001189",
                        "quarter": "2006-Q2",
                        "_id": 8
                    }, {
                        "volume_of_mobile_data": "0.001735",
                        "quarter": "2006-Q3",
                        "_id": 9
                    }, {
                        "volume_of_mobile_data": "0.003323",
                        "quarter": "2006-Q4",
                        "_id": 10
                    }],
                    "_links": {
                        "start": "/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=10",
                        "next": "/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=10&offset=10"
                    },
                    "offset": 0,
                    "limit": 10,
                    "total": 59
                }
            }
"""
        let jsonData = jsonString.data(using: .utf8)!
        let data = try! JSONDecoder().decode(MobileDataUsage.self, from: jsonData)
        return data
    }()
    
    enum FindMobileDataUseCaseError: Error {
        case someError
    }
    
    class func TestMobileDataUsage (limit:Int, offset:Int) -> MobileDataUsage{
        MobileDataListViewModelTests.mobileDataUsage.result?.limit = limit;
        MobileDataListViewModelTests.mobileDataUsage.result?.offset = offset;

        return MobileDataListViewModelTests.mobileDataUsage;
    }
    
    class FindMobileDataUseCaseMock: FindMobileDataUseCase {
        var expectation: XCTestExpectation?
        var error: Error?
        var testMobileDataUsage = TestMobileDataUsage(limit: 10, offset: 0)
    
        func execute(requestValue: FindMobileDataUseCaseRequestValue,
                     completion: @escaping (Result<MobileDataUsage, Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(mobileDataUsage))
            }
            expectation?.fulfill()
            return nil
        }
    }
    
    func test_whenFindMobileDataUseCaseRetrievesFirstPage_thenViewModelContainsOnlyFirstPage() {
        // given
        let findMobileDataUseCaseMock = FindMobileDataUseCaseMock()
        findMobileDataUseCaseMock.expectation = self.expectation(description: "contains only first page")
        findMobileDataUseCaseMock.testMobileDataUsage = MobileDataListViewModelTests.TestMobileDataUsage(limit: LIMIT, offset: 0)
        let viewModel = DefaultMobileDataListViewModel(findMobileDataUseCase:findMobileDataUseCaseMock)
        
        // when
        viewModel.didLoad()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage+1, 0)
        XCTAssertTrue(viewModel.hasMorePages)
    }
    
    func test_whenFindMobileDataUseCaseLoadNextPage_thenViewModelContainsTwoPages() {
        // given
        let findMobileDataUseCaseMock = FindMobileDataUseCaseMock()
        findMobileDataUseCaseMock.expectation = self.expectation(description: "First page loaded")
        findMobileDataUseCaseMock.testMobileDataUsage = MobileDataListViewModelTests.TestMobileDataUsage(limit: LIMIT, offset: 0)
        let viewModel = DefaultMobileDataListViewModel(findMobileDataUseCase:findMobileDataUseCaseMock)
        
        // when
        viewModel.didLoad()
        
        
        
        findMobileDataUseCaseMock.expectation = self.expectation(description: "Seond page loaded")
        findMobileDataUseCaseMock.testMobileDataUsage = MobileDataListViewModelTests.TestMobileDataUsage(limit: LIMIT, offset: 0)
        
        
        viewModel.didLoadNextPage()
        // then
        
        print(viewModel.currentPage, viewModel.hasMorePages)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage+1, 1)
        XCTAssertFalse(viewModel.hasMorePages)
    }
    
    func test_whenFindMobileDataUseCaseReturnsError_thenViewModelContainsError() {
        // given
        let findMobileDataUseCaseMock = FindMobileDataUseCaseMock()
        findMobileDataUseCaseMock.expectation = self.expectation(description: "contain errors")
        findMobileDataUseCaseMock.error = FindMobileDataUseCaseError.someError
        
        let viewModel = DefaultMobileDataListViewModel(findMobileDataUseCase:findMobileDataUseCaseMock)
        // when
        viewModel.didLoad()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(viewModel.error)
    }
}
