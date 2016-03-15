//
//  Constants.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 13/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

struct Constants {
    struct keys {
        static let foursquareClientID = "clientid"
        static let foursquareClientSecret = "clientsecret"
    }
    
    func categoryID() -> String? {
        var keys: NSDictionary?
        
        if let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = keys {
            let foursquare = dict["foursquare"] as? NSDictionary
            let cliendID = foursquare!["categoryid"] as! String
            return cliendID
        }
        
        return nil
    }
}

