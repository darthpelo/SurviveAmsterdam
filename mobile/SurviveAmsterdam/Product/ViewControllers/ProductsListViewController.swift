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
            separatorView.backgroundColor = UIColor.orange()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if searchProductList == nil { getProducts() }
    }

    @IBAction func addButtonPressed(_ sender: AnyObject) {}
    
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
        searchController.searchBar.tintColor = UIColor.white()
        searchController.searchBar.barTintColor = UIColor.orange()
        searchController.searchBar.isTranslucent = true
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func getProducts() {
        network.getProducts(userid: nil) { [weak self](result) in
            guard let strongSelf = self else { return }
            guard let result = result else { return }
            
            strongSelf.productsList = result
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    private func deleteProducts(_ index: Int) {
        // handle delete (by removing the data from your array and updating the tableview)
        if let product = productsList?[index] {
            network.delete(product, userid: getUserID(), onCompletition: { [weak self](result) in
                guard let strongSelf = self else { return }
                
                if result {
                    strongSelf.productsList?.remove(at: index)
                    DispatchQueue.main.async {
                        strongSelf.tableView.reloadData()
                    }
                }
                })
        }
    }
}

extension ProductsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            deleteProducts((indexPath as NSIndexPath).row)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchProductList?.count ?? (productsList?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.productCell.identifier, forIndexPath: indexPath) as! ProductCell
        
        let productsList = searchProductList != nil ? searchProductList : self.productsList
        
        let product = productsList![(indexPath as NSIndexPath).row]
        
        cell.productNameLabel.text = product.name
        cell.shopNameLabel.text = product.place
        
        if let image = product.productThumbnail {
            cell.thumbView.image = UIImage(data: image)?.resizeByWidth(cell.thumbView.bounds.width)
        }

        return cell
    }
}

extension ProductsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegueWithIdentifier(R.segue.productsListViewController.productDetailSegue, sender: self)
    }
}

extension ProductsListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchProductList = nil
        getProducts()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text where searchController.isActive && !query.isEmpty {
            do {
//                searchProductList = try modelManager.getProductsMatching(query)
                tableView.reloadData()
            } catch {}
        }
    }
}
