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
    
    //This method will make the call to the Flickr Api from the URL that is passed as parameter.
    //It will also serialize the JSON that is fetched from the server into a dictionnary of FlickrPhoto. (cc FlickrPhoto.swift)
    
    class func fetchPhotosFromTag(url: String, tag: String, onCompletion: @escaping FlickrResponse) -> Void {
        Alamofire.request(url).responseString { response in
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
