//
//  EEGTableViewCell.swift
//  EEG_GAE_TestApp
//
//  Created by Graeme Cox on 2017-07-06.
//  Copyright © 2017 Graeme Cox. All rights reserved.
//

import UIKit

class EEGTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var dataLengthLabel: UITextField!
    @IBOutlet weak var additionalNotes: UITextField!
    

}
