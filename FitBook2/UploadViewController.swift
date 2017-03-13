//
//  UploadViewController.swift
//  FitBook
//
//  Created by Jiwoo Lee on 3/1/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import CoreData

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var testImage: UIImageView!
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func viewDidLoad() {
        descTextField.delegate = self
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectPicture(_ sender: UIButton) {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            testImage.image = image
            if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                print("original is\(originalImage.size)")
            }
        }
        picker.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func upload(_ sender: UIButton) {
        if testImage.image == nil {
            showImageAlert()
        } else {
            if (descTextField.text?.isEmpty)! {
                showTextAlert()
            } else {
                updateDatabase()
            }
        }
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
        let approxPicSize = screenSize.width / 2

        container?.performBackgroundTask({ [weak self] (context) in
            let newPost = try? Post.createPost(by: userID!, with: (self?.descTextField.text!)!, in: context)
            print(userID)
            let originalSizePicture = (self?.testImage.image!)!
            let newSizePicture = self?.resizeImage(image: originalSizePicture, newWidth: approxPicSize)
            print("new is\(newSizePicture?.size)")
            newPost?.photo = UIImagePNGRepresentation(newSizePicture!) as NSData?
//            if (self?.testImage.image!.size.width)! > (self?.testImage.image!.size.height)! {
//                let newGrouping = try? Grouping.createBigGrouping(in: context)
//                newGrouping?.leftPost = newPost
//                print("new")
//            } else {
                print("added")
                let newGrouping = try? Grouping.findAvailableGroupingOrCreateGrouping(in: context)
                if newGrouping?.numPics == 0 {
                    newGrouping?.leftPost = newPost
                } else {
                    newGrouping?.rightPost = newPost
                }
                newGrouping?.numPics += 1
                print(newGrouping?.numPics)
            //}
            try? context.save()
            self?.printDatabaseStatistics()
        })
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
