//
//  FeedbackViewController.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 23/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit
import MessageUI

class FeedbackViewController: UIViewController {

    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("feedback", comment: "")
        self.sendButton.title = NSLocalizedString("send", comment: "")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    

    @IBAction func saveButtonPressed(sender: AnyObject) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["address@example.com"])
        composeVC.setSubject("Hello!")
        composeVC.setMessageBody(textView.text, isHTML: false)
        
        // Present the view controller modally.
        self.presentViewController(composeVC, animated: true, completion: nil)
    }
}

extension FeedbackViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
