//
//  ProfileViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/5/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var userPictures: UITableView!

    var profilePictureURL: URL? {
        didSet {
            profilePicture.image = nil
            fetchImage()
            
        }
    }
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    private func fetchImage() {
        if let url = profilePictureURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.profilePictureURL {
                    print("WORKING")
                    DispatchQueue.main.async {
                        self?.profilePicture.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let userID = defaults.string(forKey: "userID")!
        username.text = userID
        desc.text = defaults.string(forKey: "realName")
        
        profilePictureURL = URL(string: "http://graph.facebook.com/\(userID)/picture?type=large")
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
