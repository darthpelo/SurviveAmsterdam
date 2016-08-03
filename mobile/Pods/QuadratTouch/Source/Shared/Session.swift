//
//  FSSession.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

/** A handler used for authorization. */
public typealias AuthorizationHandler = (Bool, NSError?) -> Void

/** A nandler used by all endpoints. */
public typealias ResponseClosure = (result: Result) -> Void

/** A nandler for image downloading. */
public typealias DownloadImageClosure = (imageData: NSData?, error: NSError?) -> Void

/** Typealias for parameters dictionary. */
public typealias Parameters = [String:String]

/**
    Posted when session have access token, but server returns response with 401 HTTP code.
    Guaranteed to be posted an main thread.
*/
public let quadratSessionDidBecomeUnauthorizedNotification = "QuadratSessionDidBecomeUnauthorizedNotification"

private var sharedSession: Session?

public class Session {
    
    /** The coniguration. */
    let configuration: Configuration
    
    /** The session which perform all network requests. */
    let urlSession: NSURLSession
    
    /** The current authorizer. */
    var authorizer: Authorizer?
    
    /** Used as image cache for downloaded files. */
    let dataCache: DataCache
    
    /** The queue on which tasks have to call completion handlers. */
    let completionQueue: NSOperationQueue
   
    /** The keychain. */
    let keychain: Keychain
    
    /** Manages network activity indicator. */
    var networkActivityController: NetworkActivityIndicatorController?

    /**
        One can create custom logger to process all errors and responses in one place.
        Main purpose is to debug or to track all the errors accured in framework via some analytic tool.
    */
    public var logger: Logger?
    
    public lazy var users: Users = {
        return Users(session: self)
    }()
    
    public lazy var venues: Venues = {
        return Venues(session: self)
    }()
    
    public lazy var venueGroups: VenueGroups = {
        return VenueGroups(session: self)
    }()
    
    public lazy var checkins: Checkins = {
        return Checkins(session: self)
    }()
    
    public lazy var tips: Tips = {
        return Tips(session: self)
    }()
    
    public lazy var lists: Lists = {
        return Lists(session: self)
    }()
    
    public lazy var updates: Updates = {
        return Updates(session: self)
    }()
    
    public lazy var photos: Photos = {
        return Photos(session: self)
    }()
    
    public lazy var settings: Settings = {
        return Settings(session: self)
    }()
    
    public lazy var specials: Specials = {
        return Specials(session: self)
    }()
    
    public lazy var events: Events = {
        return Events(session: self)
    }()
    
    public lazy var pages: Pages = {
        return Pages(session: self)
    }()
    
    public lazy var pageUpdates: PageUpdates = {
        return PageUpdates(session: self)
    }()
    
    public lazy var multi: Multi = {
        return Multi(session: self)
    }()
    
    public init(configuration: Configuration, completionQueue: NSOperationQueue = NSOperationQueue.mainQueue()) {
        if configuration.shouldControllNetworkActivityIndicator {
            self.networkActivityController = NetworkActivityIndicatorController()
        }
        self.configuration = configuration
        self.completionQueue = completionQueue
        let URLConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        URLConfiguration.timeoutIntervalForRequest = configuration.timeoutInterval
        let delegateQueue = NSOperationQueue()
        delegateQueue.maxConcurrentOperationCount = 1
        self.urlSession = NSURLSession(configuration: URLConfiguration, delegate: nil, delegateQueue: delegateQueue)
        self.dataCache = DataCache(name: configuration.userTag)
        if configuration.debugEnabled {
            self.logger = ConsoleLogger()
        }
        self.keychain = Keychain(configuration: self.configuration)
        self.keychain.logger = self.logger
    }
    
    public class func setupSharedSessionWithConfiguration(configuration: Configuration,
        completionQueue: NSOperationQueue = NSOperationQueue.mainQueue()) {
            if sharedSession == nil {
                sharedSession = Session(configuration: configuration, completionQueue: completionQueue)
            } else {
                fatalError("You shouldn't call call setupSharedSessionWithConfiguration twice!")
            }
    }
    
    public class func getSharedSession() -> Session {
        if sharedSession == nil {
            fatalError("You must call setupSharedInstanceWithConfiguration before!")
        }
        return sharedSession!
    }
    
    /** Whether session is authorized or not. */
    public func isAuthorized() -> Bool {
        do {
            let accessToken = try self.keychain.accessToken()
            return accessToken != nil
        } catch {
            return false
        }
    }
    
    public func accessToken() -> String? {
        do {
            return try self.keychain.accessToken()
        } catch {
            return nil
        }
    }
    
    /** 
        Removes access token from keychain.
        This method doesn't post `QuadratSessionDidBecomeUnauthorizedNotification`.
    */
    public func deauthorize() {
        do {
            try self.keychain.deleteAccessToken()
            self.dataCache.clearCache()
        } catch {
            
        }
    }
    
    /** Returns cached image data. */
    public func cachedImageDataForURL(URL: NSURL) -> NSData? {
        return self.dataCache.dataForKey("\(URL.hash)")
    }
    
    /** Downloads image at URL and puts in cache. */
    public func downloadImageAtURL(URL: NSURL, completionHandler: DownloadImageClosure) {
        let request = NSURLRequest(URL: URL)
        let identifier = networkActivityController?.beginNetworkActivity()
        let task = self.urlSession.downloadTaskWithRequest(request) {
            (fileURL, response, error) -> Void in
            self.networkActivityController?.endNetworkActivity(identifier)
            var data: NSData?
            if let fileURL = fileURL {
                data = NSData(contentsOfURL: fileURL)
                self.dataCache.addFileAtURL(fileURL, withKey: "\(URL.hash)")
            }
            self.completionQueue.addOperationWithBlock {
                completionHandler(imageData: data, error: error)
            }
        }
        task.resume()
    }
    
    func processResult(result: Result) {
        if result.httpStatusCode == 401 && self.isAuthorized() {
            self.deathorizeAndNotify()
        }
       self.logger?.session(self, didReceiveResult: result)
    }

    private func deathorizeAndNotify() {
        self.deauthorize()
        dispatch_async(dispatch_get_main_queue()) {
            let name = quadratSessionDidBecomeUnauthorizedNotification
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: self)
        }
    }

}
