//
//  AlbumPhotosViewController.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/14/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import UIKit
import Moya
import Moya_ObjectMapper
import Kingfisher
import RxSwift
import RxCocoa

class AlbumPhotosViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    // RxSwift's dispose bag.
    let disposeBag = DisposeBag()
    
    // Moya's related variables.
    let apiService = JPAPIServiceSingleton.sharedInstance
    var album: Album!
    var photos = Variable<[Photo]>([])
    
    // Collection view layout's related variables.
    private let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    // MARK: - UI Components.
    
    var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - View Controller LifeCycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title.
        self.setAdjustedTitle(album.title!)
        
        // Hide the tableView controller.
        collectionView.isHidden = true
        
        // Set the current view controller as a collection view delegate.
        self.collectionView.delegate = self
        
        // Setup the activity indicator.
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        // Position Activity Indicator in the center of the view controller.
        activityIndicator.center = view.center
        
        // Hide the activity indicator when the animation stop.
        activityIndicator.hidesWhenStopped = true
        
        // Add the activity indicator to the current view.
        view.addSubview(activityIndicator)
        
        // Start activity indicator.
        activityIndicator.startAnimating()
        
        // Bind the photos to the collection view.
        photos.asObservable().bind(to: collectionView.rx.items(cellIdentifier: "photoCell")) { _, photo, cell in
            
            // Get the current photo album cell.
            let photoCell = cell as! AlbumPhotoCollectionViewCell
            
            // Load the image using king fisher.
            let placeholderImage = UIImage(named: "VLabs")
            
            // Add a black border to the image view.
            photoCell.imageView.layer.borderColor = UIColor.black.cgColor
            photoCell.imageView.layer.borderWidth = 2.0
            
            // Make sure to allow arbitrary loads to be able to load http based images.
            photoCell.imageView.kf.setImage(with: URL(string: photo.thumbnailUrl!), placeholder: placeholderImage)
            
            }.addDisposableTo(disposeBag)
        
        // Load the photos from the album.
        self.getAlbumPhotos(albumId: album.id!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        // Adjust the inset of the table view.
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.collectionView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }
    
    // MARK:- Collection view delegate implementation.
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace - 10
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // MARK: - Device orientation's related method.
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Reload the collection view to refresh the cell's sizes.
        self.collectionView.reloadData()
    }
    
    // MARK: - API calls.
    
    func getAlbumPhotos(albumId: Int) {
        
        // Get the api's response reactively.
        apiService.request(.getAlbumPhotos(albumId: albumId))
            .filterSuccessfulStatusCodes()
            .takeLast(1)
            .subscribe({ event in
                switch event {
                case .next(let response):
                    do {
                        let photos: [Photo]? = try response.mapArray(Photo.self)
                        if let photos = photos {
                            
                            self.photos.value = photos
                            
                            // Disable the activity indicator.
                            self.activityIndicator.stopAnimating()
                            
                            // Reload the tableView.
                            self.collectionView.isHidden = false
                        }
                    }
                    catch {
                        // We won't handle this error as we are sure that we can get an array from the response.
                    }
                case .error(let error):
                    let error = error as CustomStringConvertible;
                    
                    // Show an alert with the error.
                    AlertService.showGenericAlert("A problem has occurred!", message: error.description, viewController: self)
                    
                    // Stop the activity indicator.
                    self.activityIndicator.stopAnimating()
                default:
                    break
                }
            }).addDisposableTo(disposeBag)
    }
    
    // MARK: - Segue configuration.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoSelectedSegue" {
                let albumPhotosViewController = segue.destination as! AlbumPhotoViewController
                
            
                // Change the back button title of the next view controller. However, the back button
                // belongs to this view controller.
                let backItem = UIBarButtonItem()
                backItem.title = "\(album.getInitials())".uppercased() + "'s Photos"
                self.navigationItem.backBarButtonItem = backItem
            
                // Get the selected cell from the sender object.
                let cell = sender as! AlbumPhotoCollectionViewCell
            
                let indexPath = self.collectionView!.indexPath(for: cell)
            
                // Pass the selected cell index and the entire album's photos.
                albumPhotosViewController.photoIndex = (indexPath?.row)!
                albumPhotosViewController.albumPhotos = photos.value
        }
    }
}
