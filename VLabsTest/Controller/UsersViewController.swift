//
//  ViewController.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/8/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import UIKit
import Moya
import Moya_ObjectMapper
import Kingfisher
import RxSwift
import RxCocoa

class UsersViewController: UIViewController {
    
    // RxSwift's dispose bag.
    let disposeBag = DisposeBag()
    
    // Moya's related variables.
    let apiService = JPAPIServiceSingleton.sharedInstance
    var users = Variable<[User]>([])
    
    // MARK: - UI Components.
    
    var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Controller LifeCycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the tableView controller.
        tableView.isHidden = true
        
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
        
        // Bind the users to the table view.
        users.asObservable().bind(to: tableView.rx.items(cellIdentifier: "userCell")) { _, user, cell in
            // The current user cell.
            let userCell = cell as! UserTableViewCell
            
            // Configure the cell's layout.
            userCell.preservesSuperviewLayoutMargins = false
            userCell.separatorInset = UIEdgeInsets.zero
            userCell.layoutMargins = UIEdgeInsets.zero
            
            // Adding support to dynamic type.
            userCell.nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            userCell.usernameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
            userCell.emailLabel.font = UIFont.preferredFont(forTextStyle: .body)
            
            // Load the image using king fisher.
            let placeholderImage = UIImage(named: "VLabs")
            let url = URL(string: "https://i1.sndcdn.com/avatars-000300145288-wkm0hm-t500x500.jpg")!
            userCell.userImageView.kf.setImage(with: url, placeholder: placeholderImage)
            
            userCell.nameLabel.text = user.name!
            userCell.usernameLabel.text = user.username!
            userCell.emailLabel.text = user.email!
        }.addDisposableTo(disposeBag)
        
        // Load the users from the api.
        self.getUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    func getUsers() {
        
        // Get the api's response reactively.
        apiService.request(.getUsers)
            .filterSuccessfulStatusCodes()
            .takeLast(1)
            .subscribe({ event in
            switch event {
            case .next(let response):
                do {
                    let users: [User]? = try response.mapArray(User.self)
                    if let users = users {
                        
                        self.users.value = users
                        
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
        
        if segue.identifier == "userSelectedSegue" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let barViewController = segue.destination as! UserTabBarViewController
                
                // Set the tab view controller's current user.
                barViewController.user = users.value[indexPath.row]
            }
        }
    }
}
