//
//  Venues.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Venues: Endpoint {
    override var endpoint: String {
        return "venues"
    }
    
    /** https://developer.foursquare.com/docs/venues/venues */
    public func get(_ venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(venueId, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/venues/add */
    public func add(_ name: String, ll: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = "add"
            var allParameters = [Parameter.name:name, Parameter.ll:ll]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/categories */
    public func categories(_ completionHandler: ResponseClosure? = nil) -> Task {
        let path = "categories"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/explore */
    public func explore(_ parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "explore"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/managed */
    public func managed(_ parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "managed"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/search */
    public func search(_ parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "search"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/suggestcompletion */
    public func suggestcompletion(_ parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "suggestcompletion"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/timeseries */
    public func timeseries(_ parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "timeseries"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/trending */
    public func trending(_ ll: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "trending"
        var allParameters = [Parameter.ll:ll]
        allParameters += parameters
        return self.getWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    // MARK: - Aspects
    
    /** https://developer.foursquare.com/docs/venues/events */
    public func events(_ venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/events"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/herenow */
    public func herenow(_ venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/herenow"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/hours */
    public func hours(_ venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/hours"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/likes */
    public func likes(_ venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/likes"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/links */
    public func links(_ venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/links"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/listed */
    public func listed(_ venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/listed"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/menu */
    public func menu(_ venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/menu"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/nextvenues */
    public func nextvenues(_ venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/nextvenues"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/photos */
    public func photos(_ venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/photos"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/similar */
    public func similar(_ venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/similar"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/stats */
    public func stats(_ venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/stats"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/tips */
    public func tips(_ venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/tips"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/venues/claim */
    public func claim(_ venueId: String, visible: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/claim"
        let parameters = [Parameter.visible: (visible) ? "true":"false"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/dislike */
    public func dislike(_ venueId: String, dislike: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/dislike"
        let parameters = [Parameter.set: (dislike) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/edit */
    public func edit(_ venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/edit"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/flag */
    public func flag(_ venueId: String, problem: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = venueId + "/flag"
            var allParameters = [Parameter.problem:problem]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/like */
    public func like(_ venueId: String, like: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/like"
        let parameters = [Parameter.set: (like) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/proposeedit */
    public func proposeedit(_ venueId: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = venueId + "/proposeedit"
            return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/setrole */
    public func setrole(_ venueId: String, userId: String, role: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = venueId + "/setrole"
            var allParameters = [Parameter.userId:userId, Parameter.role:role]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/setsinglelocation */
    public func setsinglelocation(_ venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/setsinglelocation"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
}
