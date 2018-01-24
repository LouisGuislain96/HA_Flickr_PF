//
//  ImageGalleryViewController.swift
//  Flickr_PF_ImageGallery
//
//  Created by Louis Guislain on 23/01/2018.
//  Copyright © 2018 Louis Guislain. All rights reserved.
//

import Foundation
import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var puppyImagesCollectionView: UICollectionView!
    private var myImage = UIImage(named: "Random Picture")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutCells()
    }
    
    func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.headerReferenceSize = CGSize(width: 0, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.scrollDirection = .horizontal
        puppyImagesCollectionView!.collectionViewLayout = layout
        print(puppyImagesCollectionView.visibleCells)
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath as IndexPath) as! ImagesFeedCell
        
        cell.feedImageView.image = myImage
        return cell
    }
}
