//
//  NearShopsViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 15/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit
import QuadratTouch
import CoreLocation

final class NearShopsCell: UITableViewCell {
    
}

struct NearShop {
    var shopName:String
}

final class NearShopsViewController: UIViewController {

    var selectShopAction:((NearShop) -> ())?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var shopsList: [NearShop] = []
    private let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLocationManager()
    }

}

extension NearShopsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsList.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.nearShopCell.identifier, forIndexPath: indexPath)
        
        let shop = shopsList[indexPath.row]
        
        cell.textLabel?.text = shop.shopName
        
        return cell
    }
}

extension NearShopsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let shop = shopsList[indexPath.row]
        selectShopAction!(shop)
    }
}

extension NearShopsViewController: CLLocationManagerDelegate {
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            let session = Session.sharedSession()
            
            var parameters = location.parameters()
            let cat = Constants().categoryID() ?? ""
            parameters += [Parameter.categoryId:cat]
            parameters += [Parameter.intent:"checkin"]
            
            let searchTask = session.venues.search(parameters) { (result) -> Void in
                if let response = result.response, let venues = response["venues"] {
                    for i in 0..<venues.count {
                        let dict = venues[i] as! NSDictionary
                        let shop = NearShop(shopName: dict["name"] as! String)
                        self.shopsList.append(shop)
                        self.tableView.reloadData()
                    }
                    
                }
            }
            searchTask.start()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
