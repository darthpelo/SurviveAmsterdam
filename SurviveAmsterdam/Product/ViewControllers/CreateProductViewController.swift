//
//  CreateProductViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 08/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

final class CreateProductViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLabe: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    private let kOFFSET_FOR_KEYBOARD:CGFloat = 120.0
    private var contentOffset: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoLabe.text = NSLocalizedString("add.product.tap.label", comment: "")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("save", comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action:"saveProduct")
        navigationItem.rightBarButtonItem?.accessibilityHint = NSLocalizedString("saveHint", comment: "")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)

        photoImageView.userInteractionEnabled = true
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addNewImage"))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "closeKeyboard"))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Internal functions
    
    func addNewImage() {
        
    }
    
    func closeKeyboard() {
        textField.resignFirstResponder()
    }
    
    func saveProduct() {
        guard let name = textField.text else {
            return
        }
        
        guard let image = photoImageView.image,
            let imageRappresentation = UIImagePNGRepresentation(image) else {
                return
        }
        
        let newProduct = Product()
        
        newProduct.setupModel(name, shop: Shop(), productImage: imageRappresentation)
        
        do {
            try ModelManager().saveProduct(newProduct)
        } catch ModelManagerError.SaveFailed {
            
        } catch {
            
        }
    }
    
    func keyboardWillShow() {
        setViewMovedUp(true)
    }
    
    func keyboardWillHide() {
        setViewMovedUp(false)
    }
    
    private func setViewMovedUp(movedUp: Bool) {
        UIView.animateWithDuration(0.3) { () -> Void in
            if (movedUp) {
                self.contentOffset = self.scrollView.contentOffset.y
                self.scrollView.contentOffset = CGPointMake(0, self.kOFFSET_FOR_KEYBOARD)
            } else {
                // revert back to the normal state.
                self.scrollView.contentOffset = CGPointMake(0, self.contentOffset ?? 0)
            }
        }
    }
}

extension CreateProductViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}