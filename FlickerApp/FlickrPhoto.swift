//
//  FlickerPhoto.swift
//  FlickerApp
//
//  Created by kumaran V on 21/03/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

import Foundation
import ObjectMapper
class FlickrResponse: Mappable {
    var photos: Photos?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        photos <- map["photos"]
    }
}
class Photos: Mappable {
    var photosArray: [Photo]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        photosArray <- map["photo"]
    }
}

class Photo: Mappable {
    
    var photoId: String?
    var farm: Int?
    var secret: String?
    var title: String?
    var server: String?

    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        photoId <- map["id"]
        secret <- map["secret"]
        farm <- map["farm"]
        title <- map["title"]
        server <- map["server"]
    }
    func  photoUrl() -> String {
        return  "https://farm\(farm!).staticflickr.com/\(server!)/\(photoId!)_\(secret!).jpg"
    }
    
}
