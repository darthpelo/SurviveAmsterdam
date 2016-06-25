//
//  LocationsListViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 05/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

final class LocationCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!
    
}

final class LocationsListViewController: UIViewController {

    override func viewDidLoad() {
        title = NSLocalizedString("shops", comment: "")
    }
}

extension LocationsListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.locationCell.identifier, forIndexPath: indexPath) as! LocationCell
        
        return cell
    }
    
}

extension LocationsListViewController: UITableViewDelegate {
    
}
