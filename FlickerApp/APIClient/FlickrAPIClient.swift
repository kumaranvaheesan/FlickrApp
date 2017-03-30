//
//  FlickerAPIClient.swift
//  FlickerApp
//
//  Created by kumaran V on 21/03/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

import Foundation
import CoreLocation

protocol FlickrGetterDelegate {
    func didreceivePhotos(photosArray: [Any])
    func didNotreceivePhotos(error: NSError)
}

protocol FlickrPhotoInfoDelegate {
    func didreceivePhotoInfo(photoInfo: FlickrPhotoInfo)
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
        
        let searchTask = URLSession.shared.dataTask(with: apiURL as URL, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                print("Error fetching photos: \(error)")
                self.delegate.didNotreceivePhotos(error:error as! NSError)
                return
            }
            
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                
                guard let photosJson = resultsDictionary!["photos"] as? NSDictionary else { return
                }
                
                guard let photosArray = photosJson["photo"] as? [NSDictionary] else {
                    return
                }
                
                let flickrPhotos: [FlickrPhoto] = photosArray.map {
                    photoDictionary in
                    
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    
                    let flickrPhoto = FlickrPhoto(id: photoId, farm: farm, secret: secret, server: server, title: title)
                    return flickrPhoto
                }
                
                self.delegate.didreceivePhotos(photosArray: flickrPhotos)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                self.delegate.didNotreceivePhotos(error:error )
                return
            }
            
        })
        searchTask.resume()
    }
    
}

class FlickrPhotoInfoGetter
{
    init(delegate: FlickrPhotoInfoDelegate) {
        self.delegate = delegate
    }
    private var delegate: FlickrPhotoInfoDelegate
    
    
    func getPhotoInfo(photoId:String?) {
        
        let searchTask = URLSession.shared.dataTask(with: APIURL.webServiceURLUsingPhotoId(id: photoId) as URL, completionHandler: { data, response, error -> Void in
            
            if error != nil {
                print("Error fetching photos: \(error)")
                self.delegate.didNotreceivePhotoInfo(error: error as! NSError)
                return
            }
            
            do {
                
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                
                guard let photoInfoJson = resultsDictionary!["photo"] as? [String: Any]  else { return
                }
                
                var tagsString = ""
                var title : String!
                var photoOwner : String!
                var description : String!
                var dateTaken : String!
                
                if let titleDictionary = photoInfoJson["title"] as? [String: Any] {
                    title = titleDictionary["_content"] as! String
                }
                if let ownerDictionary = photoInfoJson["owner"] as? [String: Any] {
                    photoOwner = ownerDictionary["username"] as! String
                }
                if let descriptionDictionary = photoInfoJson["description"] as? [String: Any] {
                    description = descriptionDictionary["_content"] as! String
                    
                }
                if let datesDictionary = photoInfoJson["dates"] as? [String: Any] {
                    dateTaken = datesDictionary["taken"] as! String
                    
                }
                
                if let tagsDictionary = photoInfoJson["tags"] as? [String: Any] {
                    print(tagsDictionary)
                    
                    if let tagArray = tagsDictionary["tag"] as? [Dictionary<String, Any>]
                    {
                        print(tagArray)
                        for tagDictionary in tagArray {
                            tagsString.append("#\(tagDictionary["raw"]!) ")
                        }
                    }
                    
                }
                
                let flickrPhotoInfo = FlickrPhotoInfo(title: title, description: description, date: dateTaken,  tags: tagsString, owner: photoOwner)
                
                self.delegate.didreceivePhotoInfo(photoInfo: flickrPhotoInfo)
                
            }
            catch let error as NSError {
                print("Error parsing JSON: \(error)")
                self.delegate.didNotreceivePhotoInfo(error: error)
                return
            }
            
        })
        
        searchTask.resume()
    }
}




