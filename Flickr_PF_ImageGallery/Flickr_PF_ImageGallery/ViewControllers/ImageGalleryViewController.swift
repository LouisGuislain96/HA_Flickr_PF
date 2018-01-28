//
//  ImageGalleryViewController.swift
//  Flickr_PF_ImageGallery
//
//  Created by Louis Guislain on 23/01/2018.
//  Copyright © 2018 Louis Guislain. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct ImagesUrl {
    static let puppiesUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=9794b500403919a4389764e8570d3f04&tags=dogs&per_page=25&format=json&nojsoncallback=1&auth_token=72157665146145148-554d0292695af162&api_sig=7453229758025efbcaf4edfbfea0b9da"      // If we want to change dogs to something else, the tags in the URL have to be modified
    static let kittensUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=9794b500403919a4389764e8570d3f04&tags=cats&per_page=25&format=json&nojsoncallback=1&auth_token=72157665146145148-554d0292695af162&api_sig=4e6b559bc67df155f4b3caed0645bdf8"      // If we want to change kittens to something else, the tags in the URL have to be modified
    static let publicFeedUrl = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
        // This is a URL that returns the public feed from Flickr. The JSON format it returns does not contain the same data as
        // for the two previous ones. The fields in the JSON are not formatted the same way and it did not have time to
        // reformat in the correct way.
}


class ImageGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var firstHeaderLabel: UILabel!
    @IBOutlet weak var secondHeaderLabel: UILabel!
    @IBOutlet weak var thirdHeaderLabel: UILabel!
    @IBOutlet weak var puppyImagesCollectionView: UICollectionView!
    @IBOutlet weak var kittensImagesCollectionView: UICollectionView!
    @IBOutlet weak var publicFeedImagesCollectionView: UICollectionView!
    
    private var dataManager = DataManager()
    private var puppyPhotos: [FlickrPhoto] = []
    private var kittensPhotos: [FlickrPhoto] = []
    private var publicFeedPhotos: [FlickrPhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        performPhotosFetching(url: ImagesUrl.puppiesUrl, tag: "dogs")
        performPhotosFetching(url: ImagesUrl.kittensUrl, tag: "kittens")
        puppyImagesCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        kittensImagesCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    //MARK: - Delegate
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == puppyImagesCollectionView {
            return puppyPhotos.count
        } else if collectionView == kittensImagesCollectionView {
            return kittensPhotos.count
        } else if collectionView == publicFeedImagesCollectionView {
            return publicFeedPhotos.count
        }
        return 25       // Default value in case there is an error in the data fetching.
    }
    
    //MARK: - Datasource
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == puppyImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuppyCell", for: indexPath as IndexPath) as! ImagesFeedCell
            let data = try? Data(contentsOf: puppyPhotos[indexPath.row].photoURL as URL)
            cell.imageView.image = UIImage(data: data!)
            cell.metaDataLabel.text = puppyPhotos[indexPath.row].title
            return cell
        } else if collectionView == kittensImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KittenCell", for: indexPath as IndexPath) as! ImagesFeedCell
            let data = try? Data(contentsOf: kittensPhotos[indexPath.row].photoURL as URL)
            cell.imageView.image = UIImage(data: data!)
            cell.metaDataLabel.text = kittensPhotos[indexPath.row].title
            return cell
        }
        return UICollectionViewCell()   // Return an empty cell in case there is a problem with storing the data in the cells.
    }
        
        //  This is the part of the code that was supposed to take care of the public feed, for which I didn't have time to
        // reformat the public feed's data. The process would've been the same, but I would have needed to create a separate
        // class with different fields, and to reformat the URL of the picture given in the JSON because all elements were
        // separated with '\'. I rather focused on the things for which I had enough time to make sure most of the assignment
        // was working.
    
//        else if collectionView == publicFeedImagesCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PublicFeedCell", for: indexPath as IndexPath) as! ImagesFeedCell
//            let data = try? Data(contentsOf: publicFeedPhotos[indexPath.row].photoURL as URL)
//            cell.imageView.image = UIImage(data: data!)
//            cell.metaDataLabel.text = publicFeedPhotos[indexPath.row].title
//            return cell
//        }
    
    
    //MARK: - Private
    
    //Here, we call the DataManager class, that handles the call to the API. In this performPhotosFetching method, the pictures array are filled with the data that is fetched from Flickr's feeds.
    
    private func performPhotosFetching(url: String, tag: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DataManager.fetchPhotosFromTag(url: url, tag: tag, onCompletion: { (flickrPhotos: [FlickrPhoto]?) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if tag == "dogs" {
                self.firstHeaderLabel.text = "dogs"
                self.puppyPhotos = flickrPhotos!
                self.puppyImagesCollectionView.reloadData()
            } else if tag == "kittens" {
                self.secondHeaderLabel.text = "kittens"
                self.kittensPhotos = flickrPhotos!
                self.kittensImagesCollectionView.reloadData()
            }
        })
    }
    
    // This is the part where the data from the public feed would have been stored in the publicFeed UIImage Array.
//            else if tag == "" {
//                self.thirdHeaderLabel.text = "public feed"
//                self.publicFeedPhotos = flickrPhotos!
//                self.publicFeedImagesCollectionView.reloadData()
//            }
    
    // This method triggers the expected behavior when a cell from one of the collection view is pressed. It presents the ViewController with the tapped picture in full screen.
    
    @objc private func tap(sender: UIGestureRecognizer) {
        if let indexPath = self.puppyImagesCollectionView?.indexPathForItem(at: sender.location(in: self.puppyImagesCollectionView)) {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FullScreenPictureViewController") as? FullScreenPictureViewController {
                
                let data = try? Data(contentsOf: puppyPhotos[indexPath.row].photoURL as URL)
                if let image = UIImage(data: data!) {
                    vc.fullScreenImage = image
                    self.present(vc, animated: true, completion: nil)
                }
            }
        } else if let indexPath = self.kittensImagesCollectionView?.indexPathForItem(at: sender.location(in: self.kittensImagesCollectionView)) {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FullScreenPictureViewController") as? FullScreenPictureViewController {
                
                let data = try? Data(contentsOf: kittensPhotos[indexPath.row].photoURL as URL)
                if let image = UIImage(data: data!) {
                    vc.fullScreenImage = image
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}
