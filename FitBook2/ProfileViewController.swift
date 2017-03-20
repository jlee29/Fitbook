//
//  ProfileViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/5/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit

class ProfileViewController:  UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profilePicture: UIImageView!

    var settingsShowing = false
    
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    
    @IBAction func settings(_ sender: UIBarButtonItem) {
        if !settingsShowing {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                var leftOfView = self.settingsView.frame
                leftOfView.origin.x -= self.settingsView.frame.width
                self.settingsView.frame = leftOfView
            }, completion: nil)
            settingsShowing = true
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                var rightOfView = self.settingsView.frame
                rightOfView.origin.x += self.settingsView.frame.width
                self.settingsView.frame = rightOfView
            }, completion: nil)
            settingsShowing = false
        }
        print(settingsShowing)
        print(settingsView.frame.origin.x)
    }
    
    @IBOutlet weak var settingsView: UIView!
    
    var profilePictureURL: URL? {
        didSet {
            profilePicture.image = nil
            fetchImage()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        settingsView.removeConstraint(trailingConstraint)
        settingsView.frame.origin.x = self.view.frame.width
        settingsShowing = false
    }
    
    override func viewDidLayoutSubviews() {
        settingsView.frame.origin.x = self.view.frame.width
        settingsShowing = false
    }
    
    var fetchedResultsController: NSFetchedResultsController<Post>?
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var descTextField: UITextField!
    
    private func fetchImage() {
        if let url = profilePictureURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.profilePictureURL {
                    DispatchQueue.main.async {
                        self?.profilePicture.image = UIImage(data: imageData)
                        print(imageData)
                    }
                }
            }
        }
    }
    
    func changeDescription(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        desc.isHidden = true
        descTextField.isHidden = false
        descTextField.text = desc.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        desc.isHidden = false
        descTextField.isHidden = true
        desc.text =  descTextField.text
        let defaults = UserDefaults.standard
        defaults.set(desc.text, forKey: "userDescription")
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descTextField.delegate = self
        descTextField.isHidden = true
        desc.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeDescription(byReactingTo:)))
        tapGesture.numberOfTapsRequired = 1
        desc.addGestureRecognizer(tapGesture)
        let defaults = UserDefaults.standard
        username.text = defaults.string(forKey: "realName")
        
        if defaults.string(forKey: "userDescription") != nil {
            desc.text = defaults.string(forKey: "userDescription")
        } else {
            desc.text = "Enter a short bio"
        }
        
//        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id"]).start {
//            (connection, result, err) in
//            if err != nil {
//                print("Failed graph request")
//            }
//            
//            if let data = result as? [String:Any] {
//                let uniqueID = data["id"] as! String
//                let token = FBSDKAccessToken.current()
//                self.profilePictureURL = URL(string: "http://graph.facebook.com/\(userID!)/picture?type=large&return_ssl_resources=1&access_token=" + (token?.tokenString!)!)
//            }
//
//        }
        
//        profilePictureURL = URL(string: "http://graph.facebook.com/\(userID!)/picture?type=large&return_ssl_resources=1")
//        print(profilePictureURL)
        profilePictureURL = URL(string: defaults.string(forKey: "proPic")!)
        
        if let navBar = self.navigationController?.navigationBar  {
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: navBar.frame.height)
            let fontSize = 17
            let titleLabel = UILabel(frame: frame)
            titleLabel.text = "F I T B O O K"
            titleLabel.font = UIFont(name: "AvenirNext", size: CGFloat(fontSize))
            titleLabel.textAlignment = NSTextAlignment.center
            navBar.addSubview(titleLabel)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
