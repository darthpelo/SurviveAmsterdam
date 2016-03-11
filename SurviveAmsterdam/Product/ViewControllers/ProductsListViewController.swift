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
        
//        do {
//            let product = Product()
//            let shop = Shop()
//            shop.setupModel("ah", address: "", shopImage: nil)
//            product.setupModel("sugo", shop: shop, productImage: nil)
//            try ModelManager().saveProduct(product)
//        } catch ModelManagerError.SaveFailed {
//            print("Save failed")
//        } catch {
//            
//        }
        
        do {
            productsList = try modelManager.getProducts()
        } catch {
            //
        }
        
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(sender: AnyObject) {
        
    }
}

extension ProductsListViewController: UITableViewDataSource {
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
        
        if let image = product.productImage {
            cell.thumbView.image = UIImage(data: image)?.resizeByWidth(cell.thumbView.bounds.width)
        }

        return cell
    }
}

extension ProductsListViewController: UITableViewDelegate {
    
}
