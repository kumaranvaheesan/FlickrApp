//
//  FlickerAPIClient.swift
//  FlickerApp
//
//  Created by kumaran V on 21/03/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import CoreLocation
import UIKit

protocol FlickrGetterDelegate {
    func didreceivePhotos(photosArray: [Any])
    func didNotreceivePhotos(error: NSError)
}

protocol FlickrPhotoInfoDelegate {
    func didreceivePhotoInfo(photoInfo: PhotoInfo)
    func didNotreceivePhotoInfo(error: NSError)
}
class FlickrPhotosGetter
{
    init(delegate: FlickrGetterDelegate) {
        self.delegate = delegate
    }
    private var delegate: FlickrGetterDelegate
    
    func getPhotosUsingTags(searchText: String?) {
        
        self.searchFlickrPhotos(apiURL: APIURL.webServiceURLUsingTags(tag:searchText!))
        
    }
    
    func getPhotosUsingLocation(currentLocation:CLLocation?) {
        
        self.searchFlickrPhotos(apiURL: APIURL.webServiceURLUsingLocation(location:currentLocation))
        
    }
    
    func searchFlickrPhotos(apiURL : URL)
    {
        Alamofire.request(apiURL).responseObject { (response: DataResponse<FlickrResponse>) in
            switch(response.result) {
            case .success(_):
                let flickrResponse = response.result.value
                print (flickrResponse ?? "NO value")
                if let photoArray = flickrResponse?.photos?.photosArray  {
                    self.delegate.didreceivePhotos(photosArray: photoArray)
                    
                }
                
                break
                
            case .failure(_):
                self.delegate.didNotreceivePhotos(error: response.error as! NSError)
                
                break
                
            }
            
        }
        
    }
    
    
}

class FlickrPhotoInfoGetter
{
    init(delegate: FlickrPhotoInfoDelegate) {
        self.delegate = delegate
    }
    private var delegate: FlickrPhotoInfoDelegate
    
    
    func getPhotoInfo(photoId:String?) {
        Alamofire.request(APIURL.webServiceURLUsingPhotoId(id: photoId)).responseObject { (response: DataResponse<FlickrPhotoInfoResponse>) in
            switch(response.result) {
            case .success(_):
                let flickrResponse = response.result.value
                if let photoInfo = flickrResponse?.photo  {
                    self.delegate.didreceivePhotoInfo(photoInfo: photoInfo)
                    
                }
                break
                
            case .failure(_):
                self.delegate.didNotreceivePhotoInfo(error: response.error as! NSError)
                
                break
                
            }
            
        }
    }
    
    
    
}


