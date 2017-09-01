//
//  AlbumPhotoViewController.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/18/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import UIKit
import Kingfisher
import RxGesture
import RxSwift

class AlbumPhotoViewController: UIViewController {

    // RxSwift's dispose bag.
    let disposeBag = DisposeBag()
    
    // Here, we will get the entire photo collection and the index of the previously selected cell.
    var albumPhotos: [Photo]!
    var photoIndex: Int!
    
    // MARK: - UI Components.
    
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var imageNumber: UILabel!
    
    // MARK: - View Controller LifeCycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the user interface properties.
        setupInterfaceProperties(photo: albumPhotos[photoIndex])
        
        // Use a swap gesture recognizer to switch photos.
        // A left swipe recognizer.
        self.view.rx.swipeGesture(.left).when(.recognized).subscribe(onNext: { gesture in
            // Get the next photo.
            if (self.photoIndex < self.albumPhotos.count - 1) {
                self.photoIndex = self.photoIndex + 1
                self.setupInterfaceProperties(photo: self.albumPhotos[self.photoIndex])
                
                // Adding an animation to the photo.
                self.photoImage.layer.add(AnimationService.createAnimation(withDirection: kCATransitionFromRight), forKey: "slideFromRight")
            }
       
        })
        .disposed(by: disposeBag)
        
        // A right swipe recognizer.
        self.view.rx.swipeGesture(.right).when(.recognized).subscribe(onNext: { gesture in
            // Get the previous photo.
            if (self.photoIndex - 1 >= 0) {
                self.photoIndex = self.photoIndex - 1
                self.setupInterfaceProperties(photo: self.albumPhotos[self.photoIndex])
                
                // Adding an animation to the photo.
                self.photoImage.layer.add(AnimationService.createAnimation(withDirection: kCATransitionFromLeft), forKey: "slideFromLeft")
            }
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Setup interface properties.
    
    func setupInterfaceProperties(photo: Photo) {
        
        // Set the title.
        self.setAdjustedTitle(albumPhotos[photoIndex].title!)
        photoTitle.text = photo.title!
        
        // Here, we rely on the global variables of the view controller.
        imageNumber.text = "\(photoIndex! + 1)/\(albumPhotos.count)"
        
        // Make sure to allow arbitrary loads to be able to load http based images.
        photoImage.kf.setImage(with: URL(string: photo.url!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
