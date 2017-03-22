//
//  FlickerPhotoInfo.swift
//  FlickerApp
//
//  Created by kumaran V on 21/03/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

import Foundation
import ObjectMapper

class FlickrPhotoInfoResponse: Mappable {
    var photo: PhotoInfo?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        photo <- map["photo"]
    }
}
class PhotoInfo: Mappable {
    var title: photoTitle?
    var description: photoDescription?
    var dates: photoDates?
    var tags: photoTags?
    var owner: photoOwner?


    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        title <- map["title"]
        description <- map["description"]
        dates <- map["dates"]
        tags <- map["tags"]
        owner <- map["owner"]

    }
}
class photoTitle: Mappable {
    var titleContent: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        titleContent <- map["_content"]
    }
}
class photoDescription: Mappable {
    
    var descriptionContent: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        descriptionContent <- map["_content"]
    }
}
class photoDates: Mappable {
    var taken: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        taken <- map["taken"]
    }
}

class photoTags: Mappable {
    var tag : [tagContent]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        tag <- map["tag"]
    }
}
class tagContent: Mappable {
    var tag :String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        tag <- map["_content"]
    }
}
class photoOwner: Mappable {
    var userName: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        userName <- map["username"]
    }
}
