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

// Ifever the images don't load, copy paste the link in an internet navigator. It should say "Invalid Auth Token" in which case the only solution is for me to provide a new one, since it's related to my Authentication key.

struct ImagesUrl {
    static let puppiesUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=2154026e8f625cf212d0c93fe1c53e7b&tags=dogs&format=json&nojsoncallback=1&auth_token=72157698407506635-61c128cceae68c6a&api_sig=49d04c8e477b249c4561f7148bd152d4"
    static let kittensUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=2154026e8f625cf212d0c93fe1c53e7b&tags=cats&format=json&nojsoncallback=1&auth_token=72157698407506635-61c128cceae68c6a&api_sig=20fdebc9402376559e51b4aa89849655"
    
    //Sadly, Flickr do not provide any dynamic URL generator, which means that simply changing the tags in the URL will result in having an error response.
}


class ImageGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var firstHeaderLabel: UILabel!
    @IBOutlet weak var secondHeaderLabel: UILabel!
    @IBOutlet weak var puppyImagesCollectionView: UICollectionView!
    @IBOutlet weak var kittensImagesCollectionView: UICollectionView!
    
    private var dataManager = DataManager()
    private var puppyPhotos: [FlickrPhoto] = []
    private var kittensPhotos: [FlickrPhoto] = []
    
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
