//
//  ProductDetailViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 11/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var productImageview: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    var productId: String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let productId = productId {
            do {
                let result = try ModelManager().getProductMatchingID(productId)
                if let prod = result.first {
                    let product = Product()
                    product.copyFromProduct(prod)
                    if let image = product.productImage {
                        self.productImageview.image = UIImage(data: image)
                    }
                    self.productNameLabel.text = product.name
                    self.shopNameLabel.text = product.shops.first?.name
                }
            } catch {
                
            }
        }
    }
}
