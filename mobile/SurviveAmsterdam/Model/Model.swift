//
//  Model.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 05/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

struct Product:Equatable {
    let id:Int
    let name:String
    let place:String
    let productImage:NSData?
    let productThumbnail:NSData?
}


extension Product {
    internal func isEqual(object: AnyObject?) -> Bool {
        guard let product = object as? Product else { return false }
        return self == product
    }
}

//MARK: Equatable methods
func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}
