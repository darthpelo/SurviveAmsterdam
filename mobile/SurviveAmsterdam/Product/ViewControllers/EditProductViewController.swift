//
//  EditProductViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 24/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

class EditProductViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var shopNameTextField: UITextField!
    
    var product:Product?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let product = self.product {
            nameLabel.text = NSLocalizedString("edit.product.name.label", comment: "")
            nameTextField.text = product.name
            shopNameLabel.text = NSLocalizedString("edit.shop.name.label", comment: "")
//            shopNameTextField.text = product.shops.first?.name
            nameTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        closeKeyboard()
        
        dismiss()
    }
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        closeKeyboard()
        
        if let newName = nameTextField.text where newName.length > 0 {
//            product?.name = newName
        }
        
//        if let newShopName = shopNameTextField.text where newShopName.length > 0 {
//            if let shop = product?.shops.first, let shopId = shop.id {
//                do {
//                    let result = try ModelManager().getShopMatchingID(shopId)
//                    let newShop = Shop()
//                    newShop.copyFromShop(result.first!)
//                    newShop.name = newShopName
//                    try ModelManager().updateShop(newShop)
//                } catch ModelManagerError.UpdateFailed {
//                    print(ErrorType)
//                } catch {}
//            }
//        }
        
//        do {
//            try ModelManager().updateProduct(product!)
//        } catch ModelManagerError.UpdateFailed {
//            print(ErrorType)
//        } catch {}
    
        dismiss()
    }
    
    private func closeKeyboard() {
        nameTextField.resignFirstResponder()
        shopNameTextField.resignFirstResponder()
    }
}
