//
//  AppDelegate.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 05/03/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import QuadratTouch


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
        
        foursquareSetup()
        
        LocationManager.sharedInstance.setupLocationManager()
        
        applicationAppearance()

        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation:  AnyObject) -> Bool {
        return Session.getSharedSession().handleURL(url)
    }
    
    private func foursquareSetup() {
        var keys: NSDictionary?
        
        if let path = Bundle.main.pathForResource("keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = keys {
            let foursquare = dict["foursquare"]
            let applicationId = foursquare?[Constants.keys.foursquareClientID] as? String
            let clientKey = foursquare?[Constants.keys.foursquareClientSecret] as? String
            
            let client = Client(clientID:applicationId!,
                clientSecret:clientKey!,
                redirectURL:"surviveamsterdam://foursquare")
            let configuration = Configuration(client:client)
            Session.setupSharedSessionWithConfiguration(configuration)
        }
    }
}

extension AppDelegate {
    private func applicationAppearance() {
        UITabBar.appearance().tintColor = UIColor.orange()
        
        UINavigationBar.appearance().tintColor = UIColor.white()
        UINavigationBar.appearance().barTintColor = UIColor.orange()
        UINavigationBar.appearance().titleTextAttributes =  [
            NSFontAttributeName: R.font.sanFranciscoDisplayMedium(size: 16)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSFontAttributeName: R.font.sanFranciscoDisplayLight(size: 16)!,
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ],
            for: UIControlState.Normal
        )
    }
}

