//
//  UploadViewController.swift
//  FitBook
//
//  Created by Jiwoo Lee on 3/1/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
import Photos

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate, FilterViewControllerDelegate, UIPopoverPresentationControllerDelegate, SpecificationViewControllerDelegate {
    
    @IBAction func saveToCameraRoll(_ sender: UIBarButtonItem) {
        if defaults.string(forKey: "keyboardShowing") == "false" {
            if testImage.image != nil {
    //            UIImageWriteToSavedPhotosAlbum(testImage.image!, nil, nil, nil)
                PHPhotoLibrary.shared().performChanges({ [weak self] in
                PHAssetChangeRequest.creationRequestForAsset(from: (self?.testImage.image!)!)
                }, completionHandler: { success, error in
                    if success {
                        let alert = UIAlertController(title: "Saving Picture", message: "Successful!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        let alert = UIAlertController(title: "Saving Picture", message: "Not successful.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print ("Failed to save")
                    }
                })
            } else {
                showImageAlert()
            }
        }
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func changedImage(_ image: UIImage) {
        testImage.image = image
    }
    
    func decidedParameters(_ price: Double, size: String?, location: String?) {
        productPrice = price
        productSize = size
        productLocation = location
    }
    
    func updateViewFrame() {
        self.view.frame = self.view.bounds
        descTextView.resignFirstResponder()
    }
    
    var productPrice: Double?
    var productSize: String?
    var productLocation: String?
    
    var selling = false
    var buying = false
    
    let locationManager = CLLocationManager()
    var longitude: Double = 0.0
    var latitude:Double = 0.0
    
    var keyboardHeight: CGFloat?
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var testImage: UIImageView!
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set("false", forKey: "keyboardShowing")
        descTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        if let navBar = self.navigationController?.navigationBar  {
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: navBar.frame.height)
            let fontSize = 17
            let titleLabel = UILabel(frame: frame)
            titleLabel.text = "F I T B O O K"
            titleLabel.font = UIFont(name: "AvenirNext", size: CGFloat(fontSize))
            titleLabel.textAlignment = NSTextAlignment.center
            navBar.addSubview(titleLabel)
        }
        
        descTextView.text = "Enter a description here..."
        descTextView.textColor = UIColor.lightGray
        
        sellButton.layer.cornerRadius = 5
        sellButton.layer.borderWidth = 2.5
        sellButton.layer.borderColor = UIColor.gray.cgColor
        buyButton.layer.cornerRadius = 5
        buyButton.layer.borderWidth = 2.5
        buyButton.layer.borderColor = UIColor.gray.cgColor
        
        // cite this
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectPicture(_ sender: UIButton) {
        if defaults.string(forKey: "keyboardShowing") == "false" {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                let actionSheet = UIAlertController(title: "Image source", message: "Choose the source of your image", preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (action:UIAlertAction) in
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                }))
                actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { (action:UIAlertAction) in
                    imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                }))
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            testImage.image = image
            if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                print("original is\(originalImage.size)")
            }
        }
        picker.dismiss(animated: true, completion: nil);
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
    }
    
    @IBOutlet weak var sellButton: UIButton!
    
    @IBOutlet weak var buyButton: UIButton!
    
    @IBAction func upload(_ sender: UIButton) {
        if defaults.string(forKey: "keyboardShowing") == "false" {
            if testImage.image == nil {
                showImageAlert()
            } else {
                if (descTextView.text?.isEmpty)! {
                    showTextAlert()
                } else {
                    let alert = UIAlertController(title: "Uploading Picture...", message: "Successful!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                        print ("pressed ok")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    updateDatabase()
                }
            }
        }
    }
    
    func showPopover(as mode: String) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "specifications") as? SpecificationViewController
        popoverContent?.mode = mode
        let navController = UINavigationController(rootViewController: popoverContent!)
        navController.modalPresentationStyle = .popover
        let popover = navController.popoverPresentationController
        popoverContent?.preferredContentSize = CGSize(width: 200, height: 200)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 0, height: 0)
        popoverContent?.delegate = self
        popoverContent?.priceDouble = productPrice
        popoverContent?.productSize = productSize
        popoverContent?.productLocation = productLocation
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func WTB(_ sender: UIButton) {
        buying = true
        selling = false
        buyButton.layer.borderColor = UIColor.green.cgColor
        sellButton.layer.borderColor = UIColor.gray.cgColor
        showPopover(as: "Buying")
    }
    @IBAction func WTS(_ sender: UIButton) {
        selling = true
        buying = false
        sellButton.layer.borderColor = UIColor.green.cgColor
        buyButton.layer.borderColor = UIColor.gray.cgColor
        // cite this
        showPopover(as: "Selling")
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    private func updateDatabase() {
        let defaults = UserDefaults.standard
        let userID = defaults.string(forKey: "userID")
        let screenSize: CGRect = UIScreen.main.bounds
        let approxPicSize = screenSize.width 

        container?.performBackgroundTask({ [weak self] (context) in
            let newPost = try? Post.createPost(by: userID!, with: (self?.descTextView.text!)!, in: context)
            let originalSizePicture = (self?.testImage.image!)!
            let newSizePicture = self?.resizeImage(image: originalSizePicture, newWidth: approxPicSize)
            print("new is\(newSizePicture?.size)")
            newPost?.photo = UIImagePNGRepresentation(newSizePicture!) as NSData?
            newPost?.postedDate = Date() as NSDate
            newPost?.latitude = String(describing: (self?.latitude)!)
            newPost?.longitude = String(describing:(self?.longitude)!)
            if (self?.selling)! {
                newPost?.wantToSellOrBuy = "sell"
            } else {
                if (self?.buying)! {
                    newPost?.wantToSellOrBuy = "buy"
                } else {
                    newPost?.wantToSellOrBuy = "neither"
                }
            }
            self?.updateWithPopoverParameters(for: newPost)
            self?.printPostInfo(for: newPost)
//            if (self?.testImage.image!.size.width)! > (self?.testImage.image!.size.height)! {
//                let newGrouping = try? Grouping.createBigGrouping(in: context)
//                newGrouping?.leftPost = newPost
//                print("new")
//            } else {
            let newGrouping = try? Grouping.findAvailableGroupingOrCreateGrouping(in: context)
            if newGrouping?.numPics == 0 {
                newGrouping?.leftPost = newPost
                //newGrouping?.rightPost = nil
            } else {
                newGrouping?.rightPost = newPost
            }
            newGrouping?.numPics += 1
            //}
            try? context.save()
            self?.printDatabaseStatistics()
        })
    }
    
    func updateWithPopoverParameters(for post: Post?) {
        if productPrice != nil {
            post?.price = productPrice!
        }
        if productSize != nil {
            post?.productSize = productSize!
        }
        if productLocation != nil {
            post?.location = productLocation!
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if let userCount = (try? context.fetch(User.fetchRequest()))?.count {
                    print("\(userCount) users")
                }
                if let postCount = (try? context.fetch(Post.fetchRequest()))?.count {
                    print("\(postCount) posts")
                }
                if let groupCount = (try? context.fetch(Grouping.fetchRequest()))?.count {
                    print("\(groupCount) groups")
                }
            }
        }
    }
    private func showImageAlert() {
        let alert = UIAlertController(title: "Need To Select A Picture", message: "Please upload a picture!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            print ("pressed ok")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showTextAlert() {
        let alert = UIAlertController(title: "Need To Include Description", message: "Please include a description!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            print ("pressed ok")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            if defaults.string(forKey: "keyboardShowing") == "false" {
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -keyboardHeight!)
            }
            defaults.set("true", forKey: "keyboardShowing")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if keyboardHeight != nil {
            if defaults.string(forKey: "keyboardShowing") == "true" {
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: keyboardHeight!)
                defaults.set("false", forKey: "keyboardShowing")
            }
        }
        // http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
        if textView.text.isEmpty {
            textView.text = "Enter a description here..."
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if testImage.image == nil {
            showImageAlert()
            return false
        }
        if defaults.string(forKey: "keyboardShowing") == "true" {
            return false
        }
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if testImage.image != nil {
            let destinationViewController = segue.destination
            if let filterViewController = destinationViewController as? FilterViewController {
                filterViewController.delegate = self
                filterViewController.inputImage = testImage
            }
        }
    }
    
    func printPostInfo(for post: Post?) {
        print("Caption\(post?.caption)")
        print("Price\(post?.price)")
        print("size\(post?.productSize)")
        print("wantToSEllOrBuy\(post?.wantToSellOrBuy)")
        print("postedDate\(post?.postedDate)")
        print("location\(post?.location)")
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
