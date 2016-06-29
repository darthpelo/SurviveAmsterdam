//
//  NetworkManagerTests.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 23/06/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import XCTest

class NetworkManagerTests: XCTestCase {
    let networkManager = NetworkManager()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveProduct() {
        let expectation = expectationWithDescription("Waiting to respond")
        let product = Product(id: 112, name: NSUUID().UUIDString, place: "place", productImage: nil, productThumbnail: nil)
        
        networkManager.save(product, userid: "D91A9970-B898-47EB-B644-9C00C6ACA392", onCompletition: { (result) in
            XCTAssertTrue(result)
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10.0, handler:nil)
    }
    
    func testAllProducts() {
        let expectation = expectationWithDescription("Waiting to respond")
        
        networkManager.getCount({ (count) in
            XCTAssertTrue(count > 0)
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10.0, handler:nil)
    }
    
    func testGetProductsForUser() {
        let expectation = expectationWithDescription("Waiting to respond")
        
        networkManager.getProducts("D91A9970-B898-47EB-B644-9C00C6ACA393") { (result) in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10.0, handler:nil)
    }
    
}
