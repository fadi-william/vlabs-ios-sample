//
//  PostCommentsViewController.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/17/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import UIKit
import Moya
import Moya_ObjectMapper
import RxSwift
import RxCocoa

class PostCommentsViewController: UIViewController {

    // RxSwift's dispose bag.
    let disposeBag = DisposeBag()
    
    // Moya's related variables.
    let apiService = JPAPIServiceSingleton.sharedInstance
    var post: Post!
    var comments = Variable<[Comment]>([])
    
    // MARK: - UI Components.
    
    var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Controller LifeCycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the current view controller's title.
        self.setAdjustedTitle(post.title!)
      
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
        comments.asObservable().bind(to: tableView.rx.items(cellIdentifier: "commentCell")) { _, comment, cell in
            
            // The current comment cell.
            let commentCell = cell as! PostCommentTableViewCell
            
            // Configure the cell's layout.
            commentCell.preservesSuperviewLayoutMargins = false
            commentCell.separatorInset = UIEdgeInsets.zero
            commentCell.layoutMargins = UIEdgeInsets.zero
            
            // Adding support to dynamic type.
            commentCell.nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            commentCell.emailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
            commentCell.bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)
            
            commentCell.nameLabel.text = comment.name!
            commentCell.emailLabel.text = comment.email!
            commentCell.bodyLabel.text = comment.body!
            
            }.addDisposableTo(disposeBag)
        
            // Load the user posts from the api.
            self.getPostComments(postId: post.id!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh the table view on font change.
        NotificationCenter.default.addObserver(forName: .UIContentSizeCategoryDidChange, object: .none, queue: OperationQueue.main) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - API calls.
    
    func getPostComments(postId: Int) {
        
        // Get the api's response reactively.
        apiService.request(.getPostComments(postId: postId))
            .filterSuccessfulStatusCodes()
            .takeLast(1)
            .subscribe({ event in
                switch event {
                case .next(let response):
                    do {
                        let comments: [Comment]? = try response.mapArray(Comment.self)
                        if let comments = comments {
                            self.comments.value = comments
                            
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
        if segue.identifier == "postCommentSegue" {
            let postUserCommentOnPostViewController = segue.destination as! ComposeCommentViewController
            postUserCommentOnPostViewController.postId = post.id!
        }
    }
}
