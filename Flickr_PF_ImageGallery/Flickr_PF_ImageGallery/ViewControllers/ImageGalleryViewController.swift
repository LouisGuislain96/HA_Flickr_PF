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
    static let puppiesUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d2eab41b196d9ba760b21e0b3004b48d&tags=dogs&per_page=25&format=json&nojsoncallback=1&auth_token=72157692732686055-8f68ac933879b742&api_sig=0d875b371b9733fc646759867e51da61"      // If we want to change dogs to something else, the tags in the URL have to be modified
    static let kittensUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d2eab41b196d9ba760b21e0b3004b48d&tags=cats&per_page=25&format=json&nojsoncallback=1&auth_token=72157692732686055-8f68ac933879b742&api_sig=0d875b371b9733fc646759867e51da61"      // If we want to change kittens to something else, the tags in the URL have to be modified
    static let publicFeedUrl = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
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
        performPhotosFetching(url: ImagesUrl.publicFeedUrl, tag: "")
        puppyImagesCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
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
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = FullScreenPictureViewController()
            let data = try? Data(contentsOf: puppyPhotos[indexPath.row].photoURL as URL)
            vc.fullScreenImageView.image = UIImage(data: data!)
            self.present(vc, animated: true, completion: nil)
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
        } else if collectionView == publicFeedImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PublicFeedCell", for: indexPath as IndexPath) as! ImagesFeedCell
            let data = try? Data(contentsOf: publicFeedPhotos[indexPath.row].photoURL as URL)
            cell.imageView.image = UIImage(data: data!)
            cell.metaDataLabel.text = publicFeedPhotos[indexPath.row].title
            return cell
        }
        return UICollectionViewCell()
    }
    
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
            } else if tag == "" {
                self.thirdHeaderLabel.text = "public feed"
                self.publicFeedPhotos = flickrPhotos!
                self.publicFeedImagesCollectionView.reloadData()
            }
            
        })
        }
    
    // This method triggers the expected behavior when a cell from one of the collection view is pressed. It presents the ViewController with the tapped picture in full screen.
    //TO DO: Finish implementing the way of passing the image to the FullScreenViewController
    
    @objc private func tap(sender: UIGestureRecognizer) {
        if let indexPath = self.puppyImagesCollectionView?.indexPathForItem(at: sender.location(in: self.puppyImagesCollectionView)) {
//            let vc = FullScreenPictureViewController()
//            let data = try? Data(contentsOf: puppyPhotos[indexPath.row].photoURL as URL)
//            vc.fullScreenImageView.image = UIImage(data: data!)
//            self.present(vc, animated: true, completion: nil)
            let cell = self.puppyImagesCollectionView?.cellForItem(at: indexPath)
            print(indexPath)
            print("you can do something with the cell or index path here")
        } else {
            print("collectionView was tapped")
        }
    }
}
