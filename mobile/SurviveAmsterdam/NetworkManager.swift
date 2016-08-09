//
//  NetworkManager.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 23/06/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

struct endPoints {
    static let END_POINT = "https://surviveamsterdam.herokuapp.com/"
    
    struct httpMethods {
        static let post = "POST"
        static let get = "GET"
    }
    
    struct request {
        static let save = "save"
        static let count = "count"
        static let products = "products"
        static let delete = "delete"
    }
    
    struct query {
        static let userid = "userid"
    }
}

enum ResponseCode:String {
    case OK, NOK, PRS
}

struct NetworkManager {
    func getCount(_ products:(Int) -> Void) {
        let req = NSMutableURLRequest(url: URL(string: endPoints.END_POINT + endPoints.request.count)!)
        req.httpMethod = endPoints.httpMethods.get
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: req, completionHandler: {
            (d:Data?, res:URLResponse?, e:NSError?) -> Void in
            if let _ = e {
                print("Request failed with error \(e!)")
                products(0)
            } else {
                guard let data = d else { products(0); return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    if let result = json["count"] as? Int {
                        print("\(#function) : \(#line) : RESPONSE JSON : \(result)")
                        products(result)
                    } else {
                        print("\(#function) : \(#line) : Problem with the GET")
                        products(0)
                    }
                } catch {
                    print("\(#function) : \(#line) : ERROR: \(error)")
                    products(0)
                }
            }
        })
        
        task.resume()
    }
    
    func getProducts(userid: String?, onCompletition:([Product]?)->Void) {
        var query = ""
        if let userid = userid {
            query = "?\(endPoints.query.userid)=\(userid)"
        }
        let req = NSMutableURLRequest(url: URL(string: endPoints.END_POINT + endPoints.request.products + query)!)
        req.httpMethod = endPoints.httpMethods.get
        req.timeoutInterval = 10.0
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: req, completionHandler: { (d:Data?, res:URLResponse?, e:NSError?) -> Void in
            if let _ = e {
                print("Request failed with error \(e!)")
                onCompletition(nil)
            } else {
                guard let data = d else { onCompletition(nil); return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    if let result = json["products"] as? [[String:AnyObject]] where result.count > 0 {
                        var list:[Product] = []
                        for a in result {
                            let name = a["name"] as? String
                            let place = a["place"] as? String
                            let p = Product(id: nil, name: name!, place: place!, productImage: nil, productThumbnail: nil)
                            list.append(p)
                        }
                        print("\(#function) : \(#line) : RESPONSE JSON : \(json)")
                        onCompletition(list)
                    } else {
                        print("\(#function) : \(#line) : Problem with the GET")
                        onCompletition(nil)
                    }
                } catch {
                    print("\(#function) : \(#line) : ERROR: \(error)")
                    onCompletition(nil)
                }
                
            }
        })
        
        task.resume()
    }
    
    func save(_ product: Product, userid: String, onCompletition: (Bool) -> Void) {
        let postBody = "userid=\(userid)&name=\(product.name)&place=\(product.place)"
        
        let req = NSMutableURLRequest(url: URL(string: endPoints.END_POINT + endPoints.request.save)!)
        req.httpMethod = endPoints.httpMethods.post
        req.timeoutInterval = 10.0
        req.httpBody = postBody.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: req, completionHandler: { (d:Data?, res:URLResponse?, e:NSError?) -> Void in
            if let _ = e {
                print("Request failed with error \(e!)")
                onCompletition(false)
            } else {
                guard let data = d else { onCompletition(false); return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    if let result = json["result"] as? String {
                        switch result {
                        case ResponseCode.OK.rawValue:
                            print("\(#function) : \(#line) : RESPONSE JSON : \(json)")
                            onCompletition(true)
                        case ResponseCode.PRS.rawValue:
                            print("\(#function) : \(#line) : Duplicate item")
                            onCompletition(false)
                        default:
                            print("\(#function) : \(#line) : Problem with the POST")
                            onCompletition(false)
                        }
                    } else {
                        print("\(#function) : \(#line) : Problem with the Response")
                        onCompletition(false)
                    }
                } catch {
                    print("\(#function) : \(#line) : ERROR: \(error)")
                    onCompletition(false)
                }

            }
        })
        
        task.resume()
    }
    
    func delete(_ product: Product, userid: String, onCompletition: (Bool) -> Void) {
        let postBody = "userid=\(userid)&name=\(product.name)&place=\(product.place)"
        
        let req = NSMutableURLRequest(url: URL(string: endPoints.END_POINT + endPoints.request.delete)!)
        req.httpMethod = endPoints.httpMethods.post
        req.timeoutInterval = 10.0
        req.httpBody = postBody.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: req, completionHandler: { (d:Data?, res:URLResponse?, e:NSError?) -> Void in
            if let _ = e {
                print("Request failed with error \(e!)")
                onCompletition(false)
            } else {
                guard let data = d else { onCompletition(false); return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    if let result = json["result"] as? String {
                        switch result {
                        case ResponseCode.OK.rawValue:
                            print("\(#function) : \(#line) : RESPONSE JSON : \(json)")
                            onCompletition(true)
                        case ResponseCode.PRS.rawValue:
                            print("\(#function) : \(#line) : Duplicate item")
                            onCompletition(false)
                        default:
                            print("\(#function) : \(#line) : Problem with the POST")
                            onCompletition(false)
                        }
                    } else {
                        print("\(#function) : \(#line) : Problem with the Response")
                        onCompletition(false)
                    }
                } catch {
                    print("\(#function) : \(#line) : ERROR: \(error)")
                    onCompletition(false)
                }
                
            }
        })
        
        task.resume()
    }
}
