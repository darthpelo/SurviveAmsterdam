//
//  NetworkManager.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 23/06/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

//typealias APIServiceResponse = ([Product]?, NSError?) -> Void

struct NetworkManager {
    func getAll(products:([Product]?, NSError?) -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            products(nil,nil)
        }
    }
    
    func save(product: Product, onCompletition: (Product?, NSError?) -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            onCompletition(nil,nil)
        }
    }
}