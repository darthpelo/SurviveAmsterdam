//
//  ProductsListViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 05/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit
import RealmSwift

final class ProductCell: UITableViewCell {
    
    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
}

final class ProductsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var productsList: Results<(Product)>?
    private let modelManager = ModelManager()
    
    override func viewDidLoad() {
        title = NSLocalizedString("products", comment: "")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            productsList = try modelManager.getProducts()
        } catch {
            //
        }
        
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(sender: AnyObject) {}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == R.segue.productsListViewController.productDetailSegue.identifier,
            let indexPath = tableView.indexPathForSelectedRow,
            let list = productsList,
            let vc = segue.destinationViewController as? ProductDetailViewController {
                let product = list[indexPath.row]
                vc.productId = product.id
        }
    }
}

extension ProductsListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if let product = productsList?[indexPath.row] {
                do {
                    try ModelManager().deleteProcut(product)
                    tableView.reloadData()
                } catch ModelManagerError.DeleteFailed {
                    print(ErrorType)
                } catch {}
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.productCell.identifier, forIndexPath: indexPath) as! ProductCell
        
        guard let productsList = productsList else {
            return cell
        }
        
        let product = productsList[indexPath.row]
        
        cell.productNameLabel.text = product.name
        cell.shopNameLabel.text = product.shops.first?.name
        
        if let image = product.productThumbnail {
            cell.thumbView.image = UIImage(data: image)?.resizeByWidth(cell.thumbView.bounds.width)
        }

        return cell
    }
}

extension ProductsListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(R.segue.productsListViewController.productDetailSegue, sender: self)
    }
}
