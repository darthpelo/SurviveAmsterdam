//
//  NearShopsViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 15/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

final class NearShopsCell: UITableViewCell {
    
}

struct NearShop {
    var shopName:String
    var address:String
}

final class NearShopsViewController: UIViewController {

    var selectShopAction:((NearShop) -> ())?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var shopsList: [NearShop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LocationManager.sharedInstance.shopsList.count > 0 {
            self.shopsList = LocationManager.sharedInstance.shopsList
            self.tableView.reloadData()
        } else {
            self.activityIndicator.startAnimating()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: .updateShopsTableNotification, name: Constants.observer.newShopsList, object: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateShopsTableNotification() {
        shopsList = LocationManager.sharedInstance.shopsList
        tableView.reloadData()
        self.activityIndicator.stopAnimating()
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
        let shop = shopsList[indexPath.row]
        selectShopAction!(shop)
    }
}

private extension Selector {
    static let updateShopsTableNotification = #selector(NearShopsViewController.updateShopsTableNotification)
}
