//
//  CreateProductViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 08/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

final class CreateProductViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.placeholder = NSLocalizedString("add.product.no.name.alert", comment: "")
        }
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shopNameLabel: UITextField! {
        didSet {
            shopNameLabel.placeholder = NSLocalizedString("near.shop.name.label", comment: "")
        }
    }
    @IBOutlet weak var shopsLabel: UILabel! {
        didSet {
            shopsLabel.text = NSLocalizedString("near.shop.title.label", comment: "")
        }
    }
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    private var contentOffset: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("save", comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action: .saveProductButtonTapped)
        navigationItem.rightBarButtonItem?.accessibilityHint = NSLocalizedString("saveHint", comment: "")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == R.segue.createProductViewController.nearShopsSegue.identifier {
            if let vc = segue.destinationViewController as? NearShopsViewController {
                vc.selectShopAction = { [weak self] shop in
                    guard let strongSelf = self else {return}
                    strongSelf.setShopLabel(shop)
                }
            }
        }
    }
    
    //MARK: - Internal functions
    
    func saveProductButtonTapped() {
        guard let name = textField.text where !name.isEmpty else {
            if #available(iOS 9, *) {
                let alertController = UIAlertController(title: NSLocalizedString("alert", comment: ""), message: NSLocalizedString("add.product.no.name.alert", comment: ""), preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                let alertView = UIAlertView(title: NSLocalizedString("alert", comment: ""), message: NSLocalizedString("add.product.no.name.alert", comment: ""), delegate: self, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alertView.alertViewStyle = .Default
                alertView.show()
            }
            return
        }
        
        guard let shopName = shopNameLabel.text where !shopName.isEmpty else {
            if #available(iOS 9, *) {
                let alertController = UIAlertController(title: NSLocalizedString("alert", comment: ""), message: NSLocalizedString("add.product.no.name.alert", comment: ""), preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                let alertView = UIAlertView(title: NSLocalizedString("alert", comment: ""), message: NSLocalizedString("add.product.no.name.alert", comment: ""), delegate: self, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alertView.alertViewStyle = .Default
                alertView.show()
            }
            return
        }

        let newProduct = Product(id: nil, name: name, place: shopName, productImage: nil, productThumbnail: nil)

        
        let network = NetworkManager()
        
        network.save(newProduct, userid: getUserID()) { [weak self] (result) in
            guard let weakSelf = self else {return}
            
            if result {
                dispatch_async(dispatch_get_main_queue(), {
                    weakSelf.navigationController?.popViewControllerAnimated(true)
                })
            } else {
                let alertController = UIAlertController(title: NSLocalizedString("alert", comment: ""),
                                                        message: NSLocalizedString("server.post.error", comment: ""), preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(OKAction)
                
                dispatch_async(dispatch_get_main_queue(), {
                    weakSelf.presentViewController(alertController, animated: true, completion: nil)
                })
            }
        }
    }
    
    private func setShopLabel(shop: NearShop) {
        shopNameLabel.text = shop.shopName
    }
}

extension CreateProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

private extension Selector {
    static let saveProductButtonTapped =
        #selector(CreateProductViewController.saveProductButtonTapped)
}
