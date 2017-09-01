//
//  ComposeCommentViewController.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/18/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import UIKit
import RxSwift
import Eureka

class ComposeCommentViewController: FormViewController {
    
    // RxSwift's dispose bag.
    let disposeBag = DisposeBag()
    
    // Get the postId from the segue.
    var postId: Int!
    
    // Moya's related variables.
    let apiService = JPAPIServiceSingleton.sharedInstance
    
    // MARK: - View Controller LifeCycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The form title.
        self.title = "Post a comment"
        
        // LabelRow's default cell update. The label row is used for validation in the current form.
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            cell.textLabel?.textAlignment = .right
        }
        
        // Setup the form.
        form +++ Section("Comment")
            <<< TextRow("name"){ row in
                row.title = "Name"
                row.placeholder = "Enter your name"
                
                // Configure the row validation.
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< EmailRow("email"){
                $0.title = "Email"
                $0.placeholder = "Enter your email"
                
                // Configure the row validation.
                var rules = RuleSet<String>()
                rules.add(rule: RuleRequired())
                rules.add(rule: RuleEmail())
                
                $0.add(ruleSet: rules)
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< TextAreaRow("body"){
                $0.title = "Body"
                $0.placeholder = "Enter your comment"
                
                // Configure the row validation.
                var rules = RuleSet<String>()
                rules.add(rule: RuleRequired())
                rules.add(rule: RuleMinLength(minLength: 4))
                rules.add(rule: RuleMaxLength(maxLength: 140))
                
                $0.add(ruleSet: rules)
                $0.validationOptions = .validatesOnChange
                }.onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< ButtonRow("submit") {
                $0.title = "Submit Comment"
                
                // Disable the submit button until the user starts to fill the form.
                $0.disabled = Condition.function(["name", "email", "body"]) { form in
                    return form.isClean()
                }
                
                }.onCellSelection { cell, row in
                    // First, make sure that the form is valid before proceeding.
                    if self.form.validate().count == 0 {
                        // Get the form values.
                        let formFields = self.form.values()
                        let comment = Comment(name: formFields["name"] as! String, email: formFields["email"] as! String, body: formFields["body"] as! String, postId: self.postId)
                        
                        // Post the comment to the web service.
                        self.postUserComment(comment: comment)
                    }
        }
        
        // Enables the navigation accessory and stops navigation when a disabled row is encountered.
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        
        // Enables smooth scrolling on navigation to off-screen rows.
        animateScroll = true
        
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row.
        rowKeyboardSpacing = 20
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - API calls.
    
    func postUserComment(comment: Comment) {
        
        // Get the api's response reactively.
        apiService.request(.postUserCommentOnPost(name: comment.name!, email: comment.email!, body: comment.body!, postId: comment.postId!))
            .filterSuccessfulStatusCodes()
            .takeLast(1)
            .subscribe({ event in
                switch event {
                case .next(_):
                    do {
                        // In case the post has been posted successfully; go to the previous view controller.
                        self.navigationController?.popViewController(animated: true)
                    }
                case .error(let error):
                    let error = error as CustomStringConvertible;
                    
                    // Show an alert with the error.
                    AlertService.showGenericAlert("A problem has occurred!", message: error.description, viewController: self)
                    
                default:
                    break
                }
            }).addDisposableTo(disposeBag)
    }
}
