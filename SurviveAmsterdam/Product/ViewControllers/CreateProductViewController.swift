//
//  CreateProductViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 08/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

final class CreateProductViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLabe: UILabel!
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
    
    private var imagePicker: UIImagePickerController!
    private var productImage:UIImage?
    private var shop: Shop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoLabe.text = NSLocalizedString("add.product.tap.label", comment: "")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("save", comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action: .saveProductButtonTapped)
        navigationItem.rightBarButtonItem?.accessibilityHint = NSLocalizedString("saveHint", comment: "")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        photoImageView.userInteractionEnabled = true
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: .addNewImageTapped))
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
    
    func addNewImageTapped() {
        prepareImagePicker()
    }
    
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
        
        guard let thumbnail = photoImageView.convertImageToData() else {
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
        
        guard let image = productImage else {
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
        
        let newProduct = Product()

        let imageData = UIImageJPEGRepresentation(image, 1)
        
        if self.shop == nil {
            self.shop = Shop()
            self.shop?.setupModel(shopName, address: nil, shopImage: nil)
        }
        
        newProduct.setupModel(name, shop: shop, productImage: imageData, productThumbnail: thumbnail)
        
        let manager = ModelManager()
        
        manager.saveProduct(newProduct) { [weak self] (error) in
            guard let strongSelf = self else { return }
            
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    strongSelf.navigationController?.popViewControllerAnimated(true)
                })
            } else {
                let alertController = UIAlertController(title: NSLocalizedString("alert", comment: ""),
                                                        message: NSLocalizedString("cloudkit.auth.error", comment: ""), preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(OKAction)
                
                dispatch_async(dispatch_get_main_queue(), {
                    strongSelf.presentViewController(alertController, animated: true, completion: nil)
                })
            }
        }
    }
    
    private func setShopLabel(shop: NearShop) {
        shopNameLabel.text = shop.shopName
    }
    
    private func prepareImagePicker(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let picture = UIAlertAction(title: NSLocalizedString("camera", comment: ""), style: .Default) { (action) -> Void in
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .Camera
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        let gallery = UIAlertAction(title: NSLocalizedString("library", comment: ""), style: .Default) { (action) -> Void in
            self.openPicker()
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .Cancel, handler: nil)
        
        actionSheet.addAction(picture)
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
}

extension CreateProductViewController {
    func selectedShop(shop: NearShop) {
        self.shop = Shop()
        self.shop!.setupModel(shop.shopName, address: shop.address, shopImage: nil)
        shopNameLabel.text = shop.shopName
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
        productImage = image
    }
}

private extension Selector {
    static let saveProductButtonTapped =
        #selector(CreateProductViewController.saveProductButtonTapped)
    
    static let addNewImageTapped = #selector(CreateProductViewController.addNewImageTapped)
}
