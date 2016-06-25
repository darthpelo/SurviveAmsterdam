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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
        
        foursquareSetup()
        
        LocationManager.sharedInstance.setupLocationManager()
        
        applicationAppearance()

        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation:  AnyObject) -> Bool {
        return Session.sharedSession().handleURL(url)
    }
    
    private func foursquareSetup() {
        var keys: NSDictionary?
        
        if let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist") {
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
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.orangeColor()
        UINavigationBar.appearance().titleTextAttributes =  [
            NSFontAttributeName: R.font.sanFranciscoDisplayMedium(size: 16)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSFontAttributeName: R.font.sanFranciscoDisplayLight(size: 16)!,
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ],
            forState: UIControlState.Normal
        )
    }
}

