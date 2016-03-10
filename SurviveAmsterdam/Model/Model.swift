//
//  Model.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 05/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation
import RealmSwift

class Product: Object {
    dynamic var id: String?
    dynamic var name = ""
    dynamic var productImage:NSData?
    var shops = List<Shop>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func setupModel(name:String, shop:Shop?, productImage:NSData?) {
        self.id = NSUUID().UUIDString
        self.name = name
        self.productImage = productImage
        if let shop = shop {
            self.shops.append(shop)
        }
    }
    
    func copyFromProduct(product: Product) {
        self.id = product.id
        self.name = product.name
        self.productImage = product.productImage
        self.shops = product.shops
    }
}

class Shop: Object {
    dynamic var id: String?
    dynamic var name = ""
    dynamic var address = ""
    dynamic var shopImage:NSData?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func setupModel(name:String, address:String, shopImage:NSData?) {
        self.id = NSUUID().UUIDString
        self.name = name
        self.address = address
        self.shopImage = shopImage
    }
    
    func copyFromShop(shop: Shop) {
        self.id = shop.id
        self.name = shop.name
        self.address = shop.address
        self.shopImage = shop.shopImage
    }
}


extension Product {
    override internal func isEqual(object: AnyObject?) -> Bool {
        guard let product = object as? Product else { return false }
        return self == product
    }
}

extension Shop {
    override internal func isEqual(object: AnyObject?) -> Bool {
        guard let shop = object as? Shop else { return false }
        return self == shop
    }
}

//MARK: Equatable methods
func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}

func ==(lhs: Shop, rhs: Shop) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.address == rhs.address
}