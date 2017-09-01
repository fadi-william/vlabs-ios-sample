//
//  UserPostTableViewCell.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/14/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import UIKit

class UserPostTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
