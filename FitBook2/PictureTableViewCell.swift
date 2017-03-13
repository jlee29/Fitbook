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
    
    var leftPost: Post? {
        didSet {
            print("LEFT")
        }
    }
    
    var rightPost: Post? {
        didSet {
            print("RIGHT")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        leftPicture.layer.borderWidth = 2
        leftPicture.layer.borderColor = UIColor.white.cgColor
        rightPicture.layer.borderWidth = 2
        rightPicture.layer.borderColor = UIColor.white.cgColor
        
//        let leftLikeRecognizer = UITapGestureRecognizer(target: leftPicture, action: #selector(likedLeft(byReactingTo:)))
//        leftLikeRecognizer.numberOfTapsRequired = 2
//        leftPicture.addGestureRecognizer(leftLikeRecognizer)
//        
//        let rightLikeRecognizer = UITapGestureRecognizer(target: rightPicture, action: #selector(likedRight(byReactingTo:)))
//        rightLikeRecognizer.numberOfTapsRequired = 2
//        rightPicture.addGestureRecognizer(rightLikeRecognizer)
//        
//        let leftTapRecognizer = UITapGestureRecognizer(target: leftPicture, action: #selector(tappedLeft(byReactingTo:)))
//        leftTapRecognizer.numberOfTapsRequired = 1
//        leftPicture.addGestureRecognizer(leftTapRecognizer)
//        leftPicture.isUserInteractionEnabled = true
//        
//        let rightTapRecognizer = UITapGestureRecognizer(target: rightPicture, action: #selector(tappedRight(byReactingTo:)))
//        rightTapRecognizer.numberOfTapsRequired = 1
//        rightPicture.addGestureRecognizer(rightTapRecognizer)
//        rightPicture.isUserInteractionEnabled = true
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
    
    func tappedLeft(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        print("TAPPED LEFT")
    }
    
    func tappedRight(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        print("TAPPED RIGHT")
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
