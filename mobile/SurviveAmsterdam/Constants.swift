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
    
    struct observer {
        static let newShopsList = "com.alessioroberto.SurviveAmsterdam.newShopsList"
    }
    
    struct NSUserDefaultsKeys {
        static let userID = "com.alessioroberto.SurviveAmsterdam.userid"
    }
    
    func categoryID() -> String? {
        var keys: NSDictionary?
        
        if let path = Bundle.main.pathForResource("keys", ofType: "plist") {
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



