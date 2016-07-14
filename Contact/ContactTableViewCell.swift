//
//  ContactTableViewCell.swift
//  Contact
//
//  Created by intern on 13/07/16.
//  Copyright © 2016 intern. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
