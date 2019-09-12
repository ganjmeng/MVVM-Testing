//
//  FindMobileDataUseCaseTests.swift
//  SPHTechMobileAssignmentTests
//
//  Created by Jingmeng.Gan on 8/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
@testable import SPHTechMobileAssignment
import XCTest

class FindMobileDataUseCaseTests: XCTestCase {
    
    static let mobileDataUsage: MobileDataUsage = {
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
    
    enum MobileDataRepositorySuccessTestError: Error {
        case failedFetching
    }
   
    class MobileDataRepositorySuccessMock: MobileDatasRepository {
        func mobileDatasList(limit: Int, page: Int, completion: @escaping (Result<MobileDataUsage, Error>) -> Void) -> Cancellable? {
            completion(.success(mobileDataUsage))
            return nil
        }
    }
    
    class MobileDataRepositoryFailureMock: MobileDatasRepository {
        func mobileDatasList(limit: Int, page: Int, completion: @escaping (Result<MobileDataUsage, Error>) -> Void) -> Cancellable? {
            completion(.failure(MobileDataRepositorySuccessTestError.failedFetching))
            return nil
        }
    }
    
    func testFindMobileDataUseCase_whenSuccessfullyFetchesData_thenShoudBeCached() {
        // given
        let expectation = self.expectation(description: "Successfully Cached Data")
        expectation.expectedFulfillmentCount = 2
        
        let useCase = DefaultFindMobileDataUseCase(mobileDatasRepository: MobileDataRepositorySuccessMock())
        
        // when
        let requestValue = FindMobileDataUseCaseRequestValue(limit: 10,
                                                             page: 0)
        
        _ = useCase.execute(requestValue: requestValue) { result in
                expectation.fulfill()
        }
        // then
        
        var expectResult : MobileDataUsage? = nil;
        SPHCacheManager.sharedInstance.getObjectForKey(MOBILE_DATA_STORE_KEY) { (result : MobileDataUsage?) in
            guard let model = result else{
                print("获取失败了")
                XCTFail("SPHCacheManager loaded data error")
                return
            }
            expectResult = model
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue( (expectResult?.success ?? false) && (expectResult?.result?.records!.count)! > 0)
    }
    
    func testFindMobileDataUseCase_whenSuccessfullyFetchesData_thenMobileDataUsageSuccussAndResultMustBeTrue() {
        // given
        let expectation = self.expectation(description: "Successfully Fetches Data")
        expectation.expectedFulfillmentCount = 1
        
        let useCase = DefaultFindMobileDataUseCase(mobileDatasRepository: MobileDataRepositorySuccessMock())
        
        // then
        let requestValue = FindMobileDataUseCaseRequestValue(limit: 10,
                                                           page: 0)
        
        var expectResult : MobileDataUsage? = nil;
        _ = useCase.execute(requestValue: requestValue) { result in
            
            expectResult = try! result.get()
            expectation.fulfill()
        }
    
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue( (expectResult?.success ?? false) && (expectResult?.result?.records!.count)! > 0)
    }
    
    func testFindMobileDataUseCase_whenFailedFetchesData_thenMobileDataUsageShouldBeNil() {
        // given
        let expectation = self.expectation(description: "Failed Fetches Data")
        expectation.expectedFulfillmentCount = 1
        
        let useCase = DefaultFindMobileDataUseCase(mobileDatasRepository: MobileDataRepositoryFailureMock())
        
        // when
        let requestValue = FindMobileDataUseCaseRequestValue(limit: 10,
                                                             page: 0)
        
        var expectResult : MobileDataUsage? = nil;
        _ = useCase.execute(requestValue: requestValue) { result in
            
            expectResult = try? result.get()
            expectation.fulfill()
        }
        // then
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(expectResult == nil)
    }
}
