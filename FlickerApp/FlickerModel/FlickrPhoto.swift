
//
//  FlickerPhoto.swift
//  FlickerApp
//
//  Created by kumaran V on 21/03/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

import Foundation

struct FlickrPhoto {
    
    let id: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    func  photoUrl() -> String {
        return  "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
}


struct FlickrPhotoInfo {
    
    let title: String
    let description: String
    let date: String
    let tags: String
    let owner: String
    
}
