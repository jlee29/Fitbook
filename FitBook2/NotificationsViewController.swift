//
//  NotificationsViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/13/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsViewController: UIViewController, UITextFieldDelegate, UNUserNotificationCenterDelegate, BrandCollectionViewControllerDelegate {
    
    func selectedBrand(with brand: String?) {
        selectedBrand = brand
    }
    
    var selectedBrand: String? {
        didSet {
            let capitalizedWord = selectedBrand?.capitalized
            brandLabel.text = "Selected brand: \(capitalizedWord!)"
        }
    }
    @IBOutlet weak var brandLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var remindMessage: UITextField!
    
    var keyboardHeight: CGFloat?
    var keyboardIsShowing = false
    
    @IBAction func submitButton(_ sender: UIButton) {
        let notifCenter = UNUserNotificationCenter.current()
        
        let notifDate = datePicker.date
        
        let notifContent = UNMutableNotificationContent()
        notifContent.title = "Reminder"
        notifContent.body = remindMessage.text!
        notifContent.sound = UNNotificationSound.default()

        let calendar = Calendar(identifier: .gregorian)
        let notifDateComponents = calendar.dateComponents([.month,.day,.hour,.minute], from: notifDate)
        let notifTrigger = UNCalendarNotificationTrigger(dateMatching: notifDateComponents, repeats: false)
        
        // http://www.appcoda.com/ios10-user-notifications-guide/
        
        if selectedBrand != nil{
            let imageURL = Bundle.main.url(forResource: "\(selectedBrand!)Logo", withExtension: "png")
            do {
                let attachment = try UNNotificationAttachment(identifier: "brandPic", url: imageURL!, options: nil)
                notifContent.attachments = [attachment]
            } catch {
                print ("failed attachment")
            }
        }
        
        let request = UNNotificationRequest(identifier: "Reminder for \(remindMessage.text!)", content: notifContent, trigger: notifTrigger)
        notifCenter.add(request, withCompletionHandler: { (error) in
            if let err = error {
                print("oh no> \(err)")
            }
        })
        let alert = UIAlertController(title: "Setting Reminder for \(remindMessage.text!)", message: "Successful!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remindMessage.delegate = self
        // cite this
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        // Do any additional setup after loading the view.
        let collectionViewController = self.childViewControllers.last as? BrandCollectionViewController
        collectionViewController?.delegate = self
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
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !keyboardIsShowing {
                keyboardHeight = keyboardSize.height
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -keyboardHeight!)
                keyboardIsShowing = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if keyboardHeight != nil {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: keyboardHeight!)
        }
        keyboardIsShowing = false
        textField.resignFirstResponder()
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
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
