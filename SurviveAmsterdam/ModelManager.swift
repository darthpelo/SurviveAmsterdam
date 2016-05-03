//
//  ModelManager.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 08/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import RealmSwift
import CloudKit

enum ModelManagerError: ErrorType {
    case SaveFailed
    case QueryFailed
    case DeleteFailed
    case UpdateFailed
    case CloudKtFailed
}

class ModelManager {
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
    
    func getShopMatchingID(query:String) throws -> Results<(Shop)> {
        do {
            let realm = try Realm()
            let result = realm.objects(Shop).filter(NSPredicate(format: "id ==[c] %@", query))
            if result.count == 0 {
                throw ModelManagerError.QueryFailed
            }
            return result
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
    
    func saveProduct(newProduct: Product, completion: (ModelManagerError?) -> Void ) {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(newProduct)
                let productRecord = CloudProduct(productRecordID: newProduct.id!,
                    productRecordName: newProduct.name,
                    productRecordShopName: newProduct.shops.first?.name ?? "",
                    productRecordShopAddress: newProduct.shops.first?.address ?? "")
                
                saveOnCloudKit(productRecord, completion: { (error) in
                    if error != nil {
                        completion(ModelManagerError.CloudKtFailed)
                    } else {
                        completion(nil)
                    }
                })
            }
        } catch {
            completion(ModelManagerError.SaveFailed)
        }
    }
    
    func deleteProcut(product: Product) throws {
        deleteRecord(product.id!)
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

extension ModelManager {
    struct CloudProduct {
        let productRecordID:String
        let productRecordName:String
        let productRecordShopName:String
        let productRecordShopAddress:String
    }
    
    func getAllRecords(completionHandler: (ModelManagerError?) -> Void) {
        let predicate = NSPredicate(value: true)
        
        let query =  CKQuery(recordType: "Product", predicate: predicate)
        
        let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
        privateDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { (results, error) in
            if (results?.count == 0 || error != nil) {
                completionHandler(ModelManagerError.CloudKtFailed)
            } else {
                let realm = try! Realm()

                results?.forEach({ record in
                    let product = Product()
                    let shop = Shop()
                    shop.setupModel(record["shopName"] as! String, address: record["shopAddress"] as? String, shopImage: nil)
                    let recordID = record.recordID.recordName
                    product.setupModelID(recordID, name: record["name"] as! String, shop: shop, productImage: nil, productThumbnail: nil)
                    try! realm.write {
                        realm.add(product)
                    }
                })
                completionHandler(nil)
            }
        })
    }
    
    private func saveOnCloudKit(newProduct: CloudProduct, completion: (ModelManagerError?) -> Void ) {
        CKContainer.defaultContainer().accountStatusWithCompletionHandler { (accountStatus, error) in
            if accountStatus == .NoAccount {
                completion(ModelManagerError.CloudKtFailed)
            } else {
                let productRecordID = CKRecordID(recordName: newProduct.productRecordID)
                let productRecord = CKRecord(recordType: "Product", recordID: productRecordID)
                productRecord["name"] = newProduct.productRecordName
                productRecord["shopName"] = newProduct.productRecordShopName
                productRecord["shopAddress"] = newProduct.productRecordShopAddress
                //                productRecord["image"] = newProduct.productImage
                let myContainer = CKContainer.defaultContainer()
                let privateDatabase = myContainer.privateCloudDatabase
                privateDatabase.saveRecord(productRecord, completionHandler: { (productRecord, error) in
                    if (error == nil) {
                        print("saved on cloud")
                        completion(nil)
                    } else {
                        print("error")
                        print(error.debugDescription)
                        completion(ModelManagerError.CloudKtFailed)
                    }
                })
            }
        }
    }
    
    private func deleteRecord(id: String) {
        let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
        privateDatabase.deleteRecordWithID(CKRecordID(recordName: id)) { (recordID, error) in
            assert(error == nil)
        }
    }
}
