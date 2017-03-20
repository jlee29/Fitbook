//
//  SpecificationViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/15/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit

protocol SpecificationViewControllerDelegate {
    func decidedParameters(_ price: Double, size: String?, location: String?)
    func updateViewFrame()
}

class SpecificationViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: SpecificationViewControllerDelegate?
    
    var priceText: String?
    
    var priceDouble: Double?
    
    var productSize: String?
    
    var productLocation: String?
    
    var mode: String? {
        didSet {
            priceText = "\(mode!) Price"
        }
    }
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var priceBar: UISlider!
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        priceDouble = (Double(sender.value)*100).rounded()/100
        price.text = priceText! + ": $\(priceDouble!)"
    }

    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var size: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var extraSmallButton: UIButton!
    @IBOutlet weak var smallButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var largeButton: UIButton!
    @IBOutlet weak var extraLargeButton: UIButton!
    
    @IBAction func extraSmall(_ sender: UIButton) {
        extraSmallButton.layer.borderColor = UIColor.green.cgColor
        smallButton.layer.borderColor = UIColor.gray.cgColor
        mediumButton.layer.borderColor = UIColor.gray.cgColor
        largeButton.layer.borderColor = UIColor.gray.cgColor
        extraLargeButton.layer.borderColor = UIColor.gray.cgColor
        productSize = "extraSmall"
    }
    
    @IBAction func small(_ sender: UIButton) {
        extraSmallButton.layer.borderColor = UIColor.gray.cgColor
        smallButton.layer.borderColor = UIColor.green.cgColor
        mediumButton.layer.borderColor = UIColor.gray.cgColor
        largeButton.layer.borderColor = UIColor.gray.cgColor
        extraLargeButton.layer.borderColor = UIColor.gray.cgColor
        productSize = "small"
    }
    
    @IBAction func medium(_ sender: UIButton) {
        extraSmallButton.layer.borderColor = UIColor.gray.cgColor
        smallButton.layer.borderColor = UIColor.gray.cgColor
        mediumButton.layer.borderColor = UIColor.green.cgColor
        largeButton.layer.borderColor = UIColor.gray.cgColor
        extraLargeButton.layer.borderColor = UIColor.gray.cgColor
        productSize = "medium"
    }
    
    @IBAction func large(_ sender: UIButton) {
        extraSmallButton.layer.borderColor = UIColor.gray.cgColor
        smallButton.layer.borderColor = UIColor.gray.cgColor
        mediumButton.layer.borderColor = UIColor.gray.cgColor
        largeButton.layer.borderColor = UIColor.green.cgColor
        extraLargeButton.layer.borderColor = UIColor.gray.cgColor
        productSize = "large"
    }
    
    @IBAction func extraLarge(_ sender: UIButton) {
        extraSmallButton.layer.borderColor = UIColor.gray.cgColor
        smallButton.layer.borderColor = UIColor.gray.cgColor
        mediumButton.layer.borderColor = UIColor.gray.cgColor
        largeButton.layer.borderColor = UIColor.gray.cgColor
        extraLargeButton.layer.borderColor = UIColor.green.cgColor
        productSize = "extraLarge"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        price.text = priceText!
        locationTextField.delegate = self
        extraSmallButton.layer.borderWidth = 1.5
        smallButton.layer.borderWidth = 1.5
        mediumButton.layer.borderWidth = 1.5
        largeButton.layer.borderWidth = 1.5
        extraLargeButton.layer.borderWidth = 1.5
        extraSmallButton.layer.borderColor = UIColor.gray.cgColor
        smallButton.layer.borderColor = UIColor.gray.cgColor
        mediumButton.layer.borderColor = UIColor.gray.cgColor
        largeButton.layer.borderColor = UIColor.gray.cgColor
        extraLargeButton.layer.borderColor = UIColor.gray.cgColor
        if priceDouble != nil {
            priceBar.value = Float(priceDouble!)
        }
        if productLocation != nil {
            locationTextField.text = productLocation!
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let del = delegate {
            defaults.set("false", forKey: "keyboardShowing")
            del.updateViewFrame()
            if priceDouble != nil {
                del.decidedParameters(priceDouble!, size: productSize, location: productLocation)
            }
        }
        super.viewWillDisappear(animated)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        defaults.set("true", forKey: "keyboardShowing")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        productLocation = textField.text
        defaults.set("false", forKey: "keyboardShowing")
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
