//
//  ModelTests.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 05/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import XCTest

class ModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProduct() {
        let product = Product()
        
        let name = "sugo"
        
        XCTAssertNotNil(product, "")
        
        product.setupModel("sugo", shop: Shop(), productImage: nil)
        
        XCTAssertEqual(product.name, name)
        
        let productCopy = Product()
        productCopy.copyFromProduct(product)
        
        XCTAssertEqual(productCopy, product)
        
    }
    
    func testShop() {
        let shop = Shop()
        
        let name = "Jumbo"
        let address = "Sarphatistraat 408"
        
        XCTAssertNotNil(shop, "")
        
        XCTAssertEqual(shop.name, name)
        XCTAssertEqual(shop.address, address)
    }

}
