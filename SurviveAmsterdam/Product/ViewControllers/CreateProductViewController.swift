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
    
    private var imagePicker: UIImagePickerController!
    
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
        prepareImagePicker()
    }
    
    func closeKeyboard() {
        textField.resignFirstResponder()
    }
    
    func saveProduct() {
        guard let name = textField.text else {
            return
        }
        
        guard let imageData = photoImageView.convertImageToData() else {
                return
        }
        
        let newProduct = Product()
        
        newProduct.setupModel(name, shop: nil, productImage: imageData)
        
        do {
            try ModelManager().saveProduct(newProduct)
        } catch ModelManagerError.SaveFailed {
            
        } catch {
            
        }
        
        self.navigationController?.popViewControllerAnimated(true)
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
    
    private func prepareImagePicker(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let picture = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .Default) { (action) -> Void in
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .Camera
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        let gallery = UIAlertAction(title: NSLocalizedString("Galerij", comment: ""), style: .Default) { (action) -> Void in
            self.openPicker()
        }
        
        let cancel = UIAlertAction(title: "Annuleren", style: .Cancel, handler: nil)
        
        actionSheet.addAction(picture)
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
}

extension CreateProductViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

extension CreateProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openPicker() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.translucent = false
//            imagePicker.navigationBar.barTintColor = UIColor.rbwCobaltBlueColor()
            imagePicker.navigationBar.tintColor = .whiteColor()
            imagePicker.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor()
            ]
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)

        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoImageView.image = image?.resizeByWidth(photoImageView.bounds.width)
    }
}