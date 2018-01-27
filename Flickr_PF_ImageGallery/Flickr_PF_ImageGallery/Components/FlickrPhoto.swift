//
//  FlickrPhoto.swift
//  Flickr_PF_ImageGallery
//
//  Created by Louis Guislain on 25/01/2018.
//  Copyright © 2018 Louis Guislain. All rights reserved.
//

import Foundation

struct FlickrPhoto {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoURL: NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
}
