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
    private var myImage = UIImage(named: "Random Picture")
    let URL = "https://api.flickr.com/services/feeds/photos_public.gne"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performPhotosFetching(tag: "dogs")
        performPhotosFetching(tag: "kittens")
        performPhotosFetching(tag: "cars")
        layoutCells()
    }
    
    func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 121, height: 105)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.headerReferenceSize = CGSize(width: 0, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.scrollDirection = .horizontal
        puppyImagesCollectionView!.collectionViewLayout = layout
        kittensImagesCollectionView!.collectionViewLayout = layout
        publicFeedImagesCollectionView!.collectionViewLayout = layout
        }
    
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == puppyImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuppyCell", for: indexPath as IndexPath) as! ImagesFeedCell
            let data = try? Data(contentsOf: puppyPhotos[indexPath.hashValue].photoURL as URL)
            cell.feedImageView.image = UIImage(data: data!)
            cell.metaDataLabel.text = puppyPhotos[indexPath.hashValue].title
            return cell
        } else if collectionView == kittensImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KittenCell", for: indexPath as IndexPath) as! ImagesFeedCell
            let data = try? Data(contentsOf: kittensPhotos[indexPath.hashValue].photoURL as URL)
            cell.kittensImageView.image = UIImage(data: data!)
            cell.metaDataLabel.text = kittensPhotos[indexPath.hashValue].title
            return cell
        } else if collectionView == publicFeedImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PublicFeedCell", for: indexPath as IndexPath) as! ImagesFeedCell
            let data = try? Data(contentsOf: publicFeedPhotos[indexPath.hashValue].photoURL as URL)
            cell.publicFeedImageView.image = UIImage(data: data!)
            cell.metaDataLabel.text = publicFeedPhotos[indexPath.hashValue].title
            return cell
        }
        return UICollectionViewCell()
    }
    
    //MARK: - Private
    
    private func performPhotosFetching(tag: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DataManager.fetchPhotosFromTag(tag: tag, onCompletion: { (flickrPhotos: [FlickrPhoto]?) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if tag == "dogs" {
                self.puppyPhotos = flickrPhotos!
            } else if tag == "kittens" {
                self.kittensPhotos = flickrPhotos!
            } else if tag == "cars" {
                self.publicFeedPhotos = flickrPhotos!
            }
            
        })
        }
}
