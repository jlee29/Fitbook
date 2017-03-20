//
//  DetailsViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/11/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBAction func pressedPrint(_ sender: UIButton) {
        if image.image != nil {
            let printController = UIPrintInteractionController.shared
            
            let printInfo = UIPrintInfo.printInfo()
            printInfo.outputType = .general
            printInfo.jobName = "Print Picture"
            
            printController.printInfo = printInfo
            printController.printingItem = image.image!
            printController.present(animated: true, completionHandler: nil)
        }
    }
    
    var post: Post? {
        didSet {
            if post != nil {
                tempUsername = post?.ownedBy?.username
                tempImage =  UIImage(data: post?.photo as! Data)
                let numLikes = post?.numLikes
                tempLikes = "❤️: " + String(numLikes!)
                tempDesc = post?.caption
            }
        }
    }

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var tempUsername: String?
    var tempImage: UIImage?
    var tempLikes: String?
    var tempDesc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = tempImage
        numLikes.text = tempLikes
        desc.text = tempDesc
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if segue.identifier == "showMap" {
            if let mapViewController = destinationViewController as? MapViewController {
                mapViewController.post = post
            }
        }
        if segue.identifier == "showUser" {
            if let userInfoViewController = destinationViewController as? UserInfoViewController {
                userInfoViewController.user = post?.ownedBy
            }
        }
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
