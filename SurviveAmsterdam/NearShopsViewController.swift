//
//  NearShopsViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 15/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.shopsList = LocationManager.sharedInstance.shopsList
        self.activityIndicator.stopAnimating()
        tableView.reloadData()
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
