//
//  DetailsViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/11/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var post: Post? {
        didSet {
            tempUsername = post?.ownedBy?.username
            tempImage =  UIImage(data: post?.photo as! Data)
            tempLikes = "❤️: " + String(describing: post?.numLikes)
            tempDesc = post?.caption
        }
    }

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var tempUsername: String?
    var tempImage: UIImage?
    var tempLikes: String?
    var tempDesc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = tempUsername
        image.image = tempImage
        numLikes.text = tempLikes
        desc.text = tempDesc
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
