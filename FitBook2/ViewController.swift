//
//  ViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/2/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CoreData

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var uniqueID: String? {
        didSet {
            print("Set unique ID")
        }
    }
    
    var realname: String? {
        didSet {
            print("Set real name")
        }
    }
    
    var email: String? {
        didSet {
            print("Set email")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainImage.image = UIImage(named: "sneaker2")
        
        let loginButton = FBSDKLoginButton()
        
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y:view.frame.height - 75, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        
        loginButton.readPermissions = ["email"]
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out.")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture"]).start { (connection, result, err) in
            if err != nil {
                print("Failed graph request")
            }
            
            if let data = result as? [String:Any] {
                let dict = (data["picture"] as! NSDictionary)
                let data2 = dict["data"] as! NSDictionary
                let url = data2["url"] as! String?
                self.uniqueID = data["id"] as! String?
                self.realname = data["name"] as! String?
                self.email = data["email"] as! String?
                self.updateDatabase(withID: self.uniqueID!, name: self.realname!, email: self.email!)
                // ns user defaults
                let defaults = UserDefaults.standard
                defaults.set(self.uniqueID, forKey: "userID")
                defaults.set(self.realname, forKey: "realName")
                defaults.set(self.email, forKey: "email")
                defaults.set(url!, forKey: "proPic")
                //
                let storyboard = self.storyboard!
                let controller = storyboard.instantiateViewController(withIdentifier: "mainTabBar")
                self.present(controller, animated: true, completion: nil)
                self.printDatabaseStatistics()
            }
        }
    }
    
    func logout() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    private func updateDatabase(withID username: String, name realname: String, email contactEmail: String) {
        container?.performBackgroundTask({ (context) in
            _ = try? User.findOrCreateUser(matching: username, name: realname, email: contactEmail, in: context)
            try? context.save()
        })
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if let userCount = (try? context.fetch(User.fetchRequest()))?.count {
                    print("\(userCount) users")
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if identifier == "initialSegue" {
//            if uniqueID != nil, realname != nil {
//                print("got to here")
//                return true
//            }
//            showAlert()
//            return false
//        }
        return true
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Need To Log In", message: "Please log in with your Facebook Account first.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            print ("pressed ok")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "initialSegue" {
            let destinationViewController = segue.destination
            if let tabBarViewController = destinationViewController as? TabBarViewController {
                tabBarViewController.userID = uniqueID
            }
        }
    }


}

