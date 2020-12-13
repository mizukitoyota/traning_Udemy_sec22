//
//  CustomCellTableViewCell.swift
//  traning_Udemy_sec22
//
//  Created by Training on 2020/12/13.
//  Copyright © 2020 training. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var messegeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
