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
    
    func testAllProducts() {
        let expectation = expectationWithDescription("Waiting to respond")

        networkManager.getAll { (result, error) in
            XCTAssertNil(result)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(5.0, handler:nil)
    }
    
    func testSaveProduct() {
        let expectation = expectationWithDescription("Waiting to respond")
        let product = Product(id: 111, name: "test", productImage: nil, productThumbnail: nil)
        
        networkManager.save(product, onCompletition: { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertTrue(product == result!)
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5.0, handler:nil)
    }
    
}
