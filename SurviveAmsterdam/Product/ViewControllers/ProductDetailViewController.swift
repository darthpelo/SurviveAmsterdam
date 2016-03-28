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
    private var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("edit", comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action: .editProductButtonTapped)
        navigationItem.rightBarButtonItem?.accessibilityHint = NSLocalizedString("editHint", comment: "")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let productId = productId {
            do {
                let result = try ModelManager().getProductMatchingID(productId)
                if let prod = result.first {
                    product = Product()
                    product?.copyFromProduct(prod)
                    if let image = product?.productImage {
                        self.productImageview.image = UIImage(data: image)
                    }
                    self.productNameLabel.text = product?.name
                    self.shopNameLabel.text = product?.shops.first?.name
                }
            } catch {
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == R.segue.productDetailViewController.editProductSegue.identifier {
            if let navBar = segue.destinationViewController as? UINavigationController,
                let vc = navBar.topViewController as? EditProductViewController,
                let product = self.product {
                vc.product = product
            }
        }
    }
    
    func editProductButtonTapped() {
        self.performSegueWithIdentifier(R.segue.productDetailViewController.editProductSegue.identifier, sender: self)
    }
}

private extension Selector {
    static let editProductButtonTapped = #selector(ProductDetailViewController.editProductButtonTapped)
}
