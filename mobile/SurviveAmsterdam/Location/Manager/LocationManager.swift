//
//  LocationManager.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 20/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import QuadratTouch
import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    class var sharedInstance: LocationManager {
        struct Singleton {
            static let instance = LocationManager()
        }
        return Singleton.instance
    }
    
    private let manager = CLLocationManager()
    var shopsList: [NearShop] = []
    private var lastLocation = CLLocation()
    
    func setupLocationManager() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        if #available(iOS 9, *) {
            manager.requestLocation()
        } else {
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first where location != lastLocation {
            lastLocation = location
            
            let session = Session.getSharedSession()
            
            var parameters = location.parameters()
            let cat = Constants().categoryID() ?? ""
            parameters += [Parameter.categoryId:cat]
            parameters += [Parameter.intent:"browse"]
            parameters += [Parameter.radius:"800"]
            parameters += [Parameter.limit:"20"]
            
            let searchTask = session.venues.search(parameters) { (result) -> Void in
                if let response = result.response,
                    let venues = response["venues"] as? NSArray where venues.count > 0 {
                    self.shopsList.removeAll()
                    for i in 0..<venues.count {
                        if let dict = venues[i] as? NSDictionary,
                            let name = dict["name"] as? String,
                            let location = dict["location"] as? NSDictionary,
                            let address = location["address"] as? String {
                            if !name.containsString("Coffeeshop") {
                                let shop = NearShop(shopName: name, address: address)
                                self.shopsList.append(shop)
                            }
                        }
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(Constants.observer.newShopsList, object: nil)
                }
            }
            searchTask.start()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
