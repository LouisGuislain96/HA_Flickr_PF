//
//  FullScreenPictureViewController.swift
//  Flickr_PF_ImageGallery
//
//  Created by Louis Guislain on 28/01/2018.
//  Copyright © 2018 Louis Guislain. All rights reserved.
//

import Foundation
import UIKit

class FullScreenPictureViewController: UIViewController {
    
    @IBOutlet var fullScreenImageView: UIImageView!
    @IBOutlet var backButton: UIButton!
    
    var fullScreenImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullScreenImageView.image = fullScreenImage
    }

    // This IBAction makes the ImageGalleryViewController pop back when the backButton is pressed
    
    @IBAction func backAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageGalleryViewController") as? ImageGalleryViewController {
            present(vc, animated: true, completion: nil)
        }
    }
}
