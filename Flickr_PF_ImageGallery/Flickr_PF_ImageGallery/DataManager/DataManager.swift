//
//  DataManager.swift
//  Flickr_PF_ImageGallery
//
//  Created by Louis Guislain on 25/01/2018.
//  Copyright © 2018 Louis Guislain. All rights reserved.
//

import Foundation
import Alamofire

class DataManager {
    
    typealias FlickrResponse = ([FlickrPhoto]?) -> Void
    
    class func fetchPhotosFromTag(tag: String, onCompletion: @escaping FlickrResponse) -> Void {
        let flickrUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=ae1c82d8bc018a4706a0d14117f11f67&tags=dogs&format=json&nojsoncallback=1&auth_token=72157668924156389-3570f27e9028e87d&api_sig=f36ca5aac658484b772293230db47ed0"
        
        Alamofire.request(flickrUrl).responseString { response in
            if let error = response.result.error as? AFError {
                print("Error fetching the data\nDescription: \(error)")
                onCompletion(nil)
            }
            do {
                let resultsDictionnary = try JSONSerialization.jsonObject(with: response.data!, options: [.allowFragments]) as? [String: AnyObject]
                guard let results = resultsDictionnary else { return }
                if let statusCode = results["code"] as? Int {
                    if statusCode == 100 {
                        onCompletion(nil)
                        return
                    }
                }
                guard let photosContainer = resultsDictionnary!["photos"] as? NSDictionary else { return }
                guard let photosArray = photosContainer["photo"] as? [NSDictionary] else { return }
                
                let flickrPhotos: [FlickrPhoto] = photosArray.map { photoDictionary in
                    
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    
                    let flickrPhoto = FlickrPhoto(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                    return flickrPhoto
                }
                onCompletion(flickrPhotos)
                
            } catch {
                print("Error converting JSON into Dictionnary\nDescription: \(error)")
                return
            }
        }
        
    }
}
