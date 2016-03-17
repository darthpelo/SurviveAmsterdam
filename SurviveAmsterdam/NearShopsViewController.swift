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

protocol NearShopsViewControllerDelegate {
    func selectedShop(shop: NearShop)
}

final class NearShopsCell: UITableViewCell {
    
}

struct NearShop {
    var shopName:String
    var address:String
}

final class NearShopsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var delegate: NearShopsViewControllerDelegate?
    
    private let sum = {(shop: NearShop) -> NearShop in
        return shop
    }
    
    private var shopsList: [NearShop] = []
    private let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
        cell.detailTextLabel?.text = shop.address
        
        return cell
    }
}

extension NearShopsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.selectedShop( sum(shopsList[indexPath.row]))
    }
}

extension NearShopsViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        if #available(iOS 9, *) {
            manager.requestLocation()
        } else {
            manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
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
            parameters += [Parameter.radius:"800"]
            
            let searchTask = session.venues.search(parameters) { (result) -> Void in
                if let response = result.response,
                    let venues = response["venues"] {
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
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                }
            }
            searchTask.start()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
