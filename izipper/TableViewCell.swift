//
//  TableViewCell.swift
//  izipper
//
//  Created by Frank on 11/15/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var Item: UILabel!
    @IBOutlet var Status: UILabel!
    @IBOutlet var Switch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
