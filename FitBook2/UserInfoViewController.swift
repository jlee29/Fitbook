//
//  UserInfoViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/19/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet var proPic: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var userInfo: UILabel!
    
    var tempName: String?
    var tempDesc: String?
    var tempUserInfo: String?
    
    var profilePictureURL: URL? {
        didSet {
            proPic.image = nil
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = profilePictureURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.profilePictureURL {
                    DispatchQueue.main.async {
                        self?.proPic.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    
    var user: User? {
        didSet {
            if user != nil {
                let defaults = UserDefaults.standard
                tempName = user!.realname
                tempDesc = defaults.string(forKey: "userDescription")
                tempUserInfo = "Contact: \((user!.contactInfo)!)\n"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = tempName
        desc.text = tempDesc
        userInfo.text = tempUserInfo
        let defaults = UserDefaults.standard
        profilePictureURL = URL(string: defaults.string(forKey: "proPic")!)
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
