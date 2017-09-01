//
//  UserPostsViewController.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/13/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import UIKit
import Moya
import Moya_ObjectMapper
import RxSwift
import RxCocoa

class UserPostsViewController: UIViewController {

    // RxSwift's dispose bag.
    let disposeBag = DisposeBag()
    
    // Moya's related variables.
    let apiService = JPAPIServiceSingleton.sharedInstance
    var user: User!
    var posts = Variable<[Post]>([])
    
    // MARK: - UI Components.
    
    var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Controller LifeCycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the user from the user tab view controller.
        let userTabBarViewController = self.tabBarController as! UserTabBarViewController
        self.user = userTabBarViewController.user
        
        // Hide the tableView controller.
        tableView.isHidden = true
        
        // Set the table view's estimated row height.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
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
        
        // Bind the posts to the table view.
        posts.asObservable().bind(to: tableView.rx.items(cellIdentifier: "postCell")) { _, post, cell in
            // The current post cell.
            let postCell = cell as! UserPostTableViewCell
            
            // Configure the cell's layout.
            postCell.preservesSuperviewLayoutMargins = false
            postCell.separatorInset = UIEdgeInsets.zero
            postCell.layoutMargins = UIEdgeInsets.zero
            
            // Adding support to dynamic type.
            postCell.title.font = UIFont.preferredFont(forTextStyle: .headline)
            postCell.body.font = UIFont.preferredFont(forTextStyle: .body)
            
            postCell.title.text = post.title!
            postCell.body.text = post.body!
        }.addDisposableTo(disposeBag)
        
        // Load the user posts from the api.
        self.getUserPosts(userId: user.id!)
    }
    
    override func viewDidLayoutSubviews() {
        
        // Adjust the inset of the table view.
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the title of the current view controller.
        self.tabBarController?.navigationItem.title = self.user.name! + " 's Posts"
        
        // Refresh the table view on font change.
        NotificationCenter.default.addObserver(forName: .UIContentSizeCategoryDidChange, object: .none, queue: OperationQueue.main) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - API calls.
    
    func getUserPosts(userId: Int) {
        
        // Get the api's response reactively.
        apiService.request(.getUserPosts(userId: userId))
            .filterSuccessfulStatusCodes()
            .takeLast(1)
            .subscribe({ event in
                switch event {
                case .next(let response):
                    do {
                        let posts: [Post]? = try response.mapArray(Post.self)
                        if let posts = posts {
                            
                            self.posts.value = posts
                            
                            // Disable the activity indicator.
                            self.activityIndicator.stopAnimating()
                            
                            // Reload the tableView.
                            self.tableView.isHidden = false
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
        if segue.identifier == "postSelectedSegue" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let postCommentsViewController = segue.destination as! PostCommentsViewController
                
                // Change the back button title of the next view controller. However, the back button 
                // belongs to this view controller.
                let backItem = UIBarButtonItem()
                backItem.title = "\(user.getInitials())'s Posts"
                self.tabBarController?.navigationItem.backBarButtonItem = backItem
                
                // Get the selected post.
                let post = posts.value[indexPath.row]
                
                // Set the selected post.
                postCommentsViewController.post = post
            }
        }
    }
}
