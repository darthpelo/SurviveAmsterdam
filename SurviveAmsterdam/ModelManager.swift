//
//  ModelManager.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 08/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import RealmSwift

enum ModelManagerError: ErrorType {
    case SaveFailed
    case QueryFailed
    case DeleteFailed
    case UpdateFailed
}

struct ModelManager {
    func getShops() throws -> Results<(Shop)> {
        do {
            let realm = try Realm()
            return realm.objects(Shop)
        } catch {
            throw ModelManagerError.QueryFailed
        }
    }
    
    func getShopsMatching(query:String) throws -> Results<(Shop)> {
        do {
            let realm = try Realm()
            return realm.objects(Shop).filter(NSPredicate(format: "name CONTAINS[c] %@", query))
        } catch {
            throw ModelManagerError.QueryFailed
        }
    }
    
    func saveShop(newShop: Shop) throws {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(newShop)
            }
        } catch {
            throw ModelManagerError.SaveFailed
        }
    }
    
    func deleteShop(shop: Shop) throws {
        let realm = try! Realm()
        
        do {
            
            try realm.write {
                realm.delete(shop)
            }
        } catch {
            throw ModelManagerError.DeleteFailed
        }
    }
    
    func updateShop(shop: Shop) throws {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(shop, update: true)
            }
        } catch {
            throw ModelManagerError.UpdateFailed
        }
    }
    
    func getProducts() throws -> Results<(Product)> {
        do {
            let realm = try Realm()
            return realm.objects(Product)
        } catch {
            throw ModelManagerError.QueryFailed
        }
    }
    
    func getProductsMatching(query:String) throws -> Results<(Product)> {
        do {
            let realm = try Realm()
            return realm.objects(Product).filter(NSPredicate(format: "name CONTAINS[c] %@", query))
        } catch {
            throw ModelManagerError.QueryFailed
        }
    }
    
    func getProductMatchingID(query:String) throws -> Results<(Product)> {
        do {
            let realm = try Realm()
            let result = realm.objects(Product).filter(NSPredicate(format: "id ==[c] %@", query))
            if result.count == 0 {
                throw ModelManagerError.QueryFailed
            }
            return result
        } catch {
            throw ModelManagerError.QueryFailed
        }
    }
    
    func saveProduct(newProduct: Product) throws {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(newProduct)
            }
        } catch {
            throw ModelManagerError.SaveFailed
        }
    }
    
    func deleteProcut(product: Product) throws {
        let realm = try! Realm()
        
        do {
            
            try realm.write {
                realm.delete(product)
            }
        } catch {
            throw ModelManagerError.DeleteFailed
        }
    }
    
    func updateProduct(product: Product) throws {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(product, update: true)
            }
        } catch {
            throw ModelManagerError.UpdateFailed
        }
    }
}
