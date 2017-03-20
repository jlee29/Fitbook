//
//  PictureTableViewCell.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/6/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit

class PictureTableViewCell: UITableViewCell {

    @IBOutlet weak var leftPicture: UIImageView!
    @IBOutlet weak var rightPicture: UIImageView!
    
    var leftPost: Post?
    
    var rightPost: Post?

    override func awakeFromNib() {
        super.awakeFromNib()
//        if leftPost != nil {
//            leftPicture.image = UIImage(data: (leftPost?.photo)! as Data, scale: 1.0)
//        }
//        if rightPost != nil {
//            rightPicture.image = UIImage(data: (rightPost?.photo)! as Data, scale: 1.0)
//        }
        leftPicture.clipsToBounds = true
        rightPicture.clipsToBounds = true
    }
    
    
    func likedLeft(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if leftPost != nil {
            leftPost!.numLikes += 1
        }
    }
    
    func likedRight(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if rightPost != nil {
            rightPost!.numLikes += 1
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
