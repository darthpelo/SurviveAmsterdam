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
        static let sapost = "SAPost"
        static let count = "Count"
        static let products = "products"
    }
}

struct NetworkManager {
    func getCount(products:(Int) -> Void) {
        let req = NSMutableURLRequest(URL: NSURL(string: endPoints.END_POINT + endPoints.request.count)!)
        req.HTTPMethod = endPoints.httpMethods.get
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (d:NSData?, res:NSURLResponse?, e:NSError?) -> Void in
            if let _ = e {
                print("Request failed with error \(e!)")
                products(0)
            } else {
                guard let data = d else { products(0); return }
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                    if let result = json["count"] as? Int {
                        print("\(#function) : \(#line) : RESPONSE JSON : \(result)")
                        products(result)
                    } else {
                        print("\(#function) : \(#line) : Problem with the POST")
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
    
    func getProducts(userid: String, onCompletition:([Product]?)->Void) {
//        let getBody = "userid=\(userid)"
        let req = NSMutableURLRequest(URL: NSURL(string: endPoints.END_POINT + endPoints.request.products + "?userid=\(userid)")!)
        req.HTTPMethod = endPoints.httpMethods.get
        req.timeoutInterval = 10.0
//        req.HTTPBody = getBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(req, completionHandler: { (d:NSData?, res:NSURLResponse?, e:NSError?) -> Void in
            if let _ = e {
                print("Request failed with error \(e!)")
                onCompletition(nil)
            } else {
                guard let data = d else { onCompletition(nil); return }
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                    print(json)
                    if let result = json["products"] as? [[String:AnyObject]] where result.count > 0 {
                        var list:[Product] = []
                        for a in result {
//                            let userid = a["userid"] as? String
                            let name = a["name"] as? String
                            let place = a["place"] as? String
//                            let timestamp = a["time"] as? Double
                            let p = Product(id: 112, name: name!, place: place!, productImage: nil, productThumbnail: nil)
                            list.append(p)
                        }
                        print("\(#function) : \(#line) : RESPONSE JSON : \(json)")
                        onCompletition(list)
                    } else {
                        print("\(#function) : \(#line) : Problem with the POST")
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
    
    func save(product: Product, userid: String, onCompletition: (Bool) -> Void) {
        let postBody = "userid=\(userid)&name=\(product.name)&place=\(product.place)"
        
        let req = NSMutableURLRequest(URL: NSURL(string: endPoints.END_POINT + endPoints.request.sapost)!)
        req.HTTPMethod = endPoints.httpMethods.post
        req.timeoutInterval = 10.0
        req.HTTPBody = postBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (d:NSData?, res:NSURLResponse?, e:NSError?) -> Void in
            if let _ = e {
                print("Request failed with error \(e!)")
                onCompletition(false)
            } else {
                guard let data = d else { onCompletition(false); return }
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                    if let result = json["result"] as? String where result == "OK" {
                        print("\(#function) : \(#line) : RESPONSE JSON : \(json)")
                        onCompletition(true)
                    } else {
                        print("\(#function) : \(#line) : Problem with the POST")
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