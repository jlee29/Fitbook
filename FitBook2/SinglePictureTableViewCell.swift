//
//  SinglePictureTableViewCell.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/11/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit

class SinglePictureTableViewCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
