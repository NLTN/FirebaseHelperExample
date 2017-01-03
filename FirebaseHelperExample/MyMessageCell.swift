//
//  MyMessageCell.swift
//  FirebaseHelperExample
//
//  Created by Nguyen Nguyen on 1/2/17.
//  Copyright © 2017 Nguyen Nguyen. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {

    @IBOutlet weak var lblBody: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
