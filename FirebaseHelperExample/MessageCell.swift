//
//  MessageCell.swift
//  FirebaseHelperExample
//
//  Created by Nguyen Nguyen on 1/1/17.
//  Copyright © 2017 Nguyen Nguyen. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var lblSender: UILabel!
    @IBOutlet weak var lblBody: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
