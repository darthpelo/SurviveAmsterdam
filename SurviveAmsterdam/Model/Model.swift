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
    
    func setupModel(name:String?, shop:Shop, productImage:NSData?) {
        self.id = NSUUID().UUIDString
        self.name = name ?? ""
        self.productImage = productImage
        self.shops.append(shop)
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
}


extension Product {
    override internal func isEqual(object: AnyObject?) -> Bool {
        guard let product = object as? Product else { return false }
        return self == product
    }
}

//MARK: Equatable methods
func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}