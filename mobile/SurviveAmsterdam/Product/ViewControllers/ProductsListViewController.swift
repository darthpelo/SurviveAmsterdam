//
//  ProductsListViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 05/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

final class ProductCell: UITableViewCell {
    
    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = UIColor.orangeColor()
        }
    }
}

final class ProductsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var productsList: [Product]?
    private var searchProductList: [Product]?
    private let network = NetworkManager()
    
    private var searchController:UISearchController = UISearchController(searchResultsController: nil)
//    private var productsSearchResults:Results<(Product)>?
    
    override func viewDidLoad() {
        title = NSLocalizedString("products", comment: "")
        setupSearchBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        if searchProductList == nil { getProducts() }
    }

    @IBAction func addButtonPressed(sender: AnyObject) {}
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == R.segue.productsListViewController.productDetailSegue.identifier,
//            let indexPath = tableView.indexPathForSelectedRow {
//            let list = searchProductList != nil ? searchProductList : productsList
//            if let vc = segue.destinationViewController as? ProductDetailViewController {
//                let product = list![indexPath.row]
//                vc.productId = product.id
//            }
//        }
//    }

    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        if #available(iOS 9.0, *) {
            searchController.loadViewIfNeeded()
        } else {
            searchController.searchBar.sizeToFit()
        }
        searchController.searchBar.placeholder = NSLocalizedString("searchbar.placeolder", comment: "")
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.barTintColor = UIColor.orangeColor()
        searchController.searchBar.translucent = true
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func getProducts() {
        network.getProducts(userid: nil) { [weak self](result) in
            guard let strongSelf = self else { return }
            guard let result = result else { return }
            
            strongSelf.productsList = result
            dispatch_async(dispatch_get_main_queue()) {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    private func deleteProducts(index: Int) {
        // handle delete (by removing the data from your array and updating the tableview)
        if let product = productsList?[index] {
            network.delete(product, userid: getUserID(), onCompletition: { [weak self](result) in
                guard let strongSelf = self else { return }
                
                if result {
                    strongSelf.productsList?.removeAtIndex(index)
                    dispatch_async(dispatch_get_main_queue()) {
                        strongSelf.tableView.reloadData()
                    }
                }
                })
        }
    }
}

extension ProductsListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            deleteProducts(indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchProductList?.count ?? (productsList?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.productCell.identifier, forIndexPath: indexPath) as! ProductCell
        
        let productsList = searchProductList != nil ? searchProductList : self.productsList
        
        let product = productsList![indexPath.row]
        
        cell.productNameLabel.text = product.name
        cell.shopNameLabel.text = product.place
        
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

extension ProductsListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchProductList = nil
        getProducts()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let query = searchController.searchBar.text where searchController.active && !query.isEmpty {
            do {
//                searchProductList = try modelManager.getProductsMatching(query)
                tableView.reloadData()
            } catch {}
        }
    }
}
