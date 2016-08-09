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
            NotificationCenter.default.addObserver(self, selector: .updateShopsTableNotification, name: NSNotification.Name(rawValue: Constants.observer.newShopsList), object: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateShopsTableNotification() {
        shopsList = LocationManager.sharedInstance.shopsList
        tableView.reloadData()
        self.activityIndicator.stopAnimating()
    }
}

extension NearShopsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.nearShopCell.identifier, forIndexPath: indexPath)
        
        let shop = shopsList[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = shop.shopName
        cell.detailTextLabel?.text = shop.address
        
        return cell
    }
}

extension NearShopsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let shop = shopsList[(indexPath as NSIndexPath).row]
        selectShopAction!(shop)
    }
}

private extension Selector {
    static let updateShopsTableNotification = #selector(NearShopsViewController.updateShopsTableNotification)
}
