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
    @IBOutlet weak var textField: UITextField!
    
    private let kOFFSET_FOR_KEYBOARD:CGFloat = 120.0
    private var contentOffset: CGFloat?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
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
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
}