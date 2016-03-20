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
import RealmSwift
import QuadratTouch


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        
        realmMigration()
        
        foursquareSetup()
        
        LocationManager.sharedInstance.setupLocationManager()

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
    
    private func realmMigration() {
        let config = Realm.Configuration(
            schemaVersion: 3,
            
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    migration.enumerate(Product.className()) { oldObject, newObject in
                        let imageData = oldObject!["productImage"] as? NSData
                        newObject!["productThumbnail"] = imageData
                    }
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
        
        do {
            let _ = try Realm()
        } catch let error as NSError {
            // handle error
            print("\(error.debugDescription)")
        }

    }
}

