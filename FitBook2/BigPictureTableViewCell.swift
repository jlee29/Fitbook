//
//  BigPictureTableViewCell.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/7/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit

class BigPictureTableViewCell: UITableViewCell {

    @IBOutlet weak var bigPicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
