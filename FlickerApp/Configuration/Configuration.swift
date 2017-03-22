//
//  Configuration.swift
//  FlickerApp
//
//  Created by kumaran V on 21/03/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

import Foundation
import CoreLocation
private struct Constants {
    
    static let APIKey = "bc8b6f460ea043d4953dcaf0d627437f"
    static let flickrBaseURL = "https://api.flickr.com/services/rest/"
    static let additionalFlickrParams = "per_page=20&format=json&nojsoncallback=1"
    static let radius = "20"     //radius for geographical location search
    static let searchMethod = "flickr.photos.search"
    static let infoMethod = "flickr.photos.getInfo"
    
    
}
struct APIURL {
    
    static var flickrURL:URL!
    static func webServiceURLUsingTags(tag: String) -> URL
    {
        let escapedTag: String = tag.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
        
        flickrURL = URL(string: "\(Constants.flickrBaseURL)?method=\(Constants.searchMethod)&\(Constants.additionalFlickrParams)&tags=\(escapedTag)&api_key=\(Constants.APIKey)")!
        
        return flickrURL
    }
    
    static func webServiceURLUsingLocation(location: CLLocation?) -> URL
    {
        if let searchLocation = location{
            flickrURL = URL(string: "\(Constants.flickrBaseURL)?method=\(Constants.searchMethod)&\(Constants.additionalFlickrParams)&lat=\(searchLocation.coordinate.latitude)&&lon=\(searchLocation.coordinate.longitude)&api_key=\(Constants.APIKey)&radius=\(Constants.radius)")!
        }
        
        return flickrURL
    }
    
    static func webServiceURLUsingPhotoId(id: String?) -> URL
    {
        if let photo_Id = id{
            flickrURL = URL(string: "\(Constants.flickrBaseURL)?method=\(Constants.infoMethod)&\(Constants.additionalFlickrParams)&photo_id=\(photo_Id)&api_key=\(Constants.APIKey)")!
        }
        
        return flickrURL
    }
    
    
}
