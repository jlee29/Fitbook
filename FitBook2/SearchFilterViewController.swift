//
//  SearchFilterViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/16/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit

protocol SearchFilterViewControllerDelegate {
    func decidedParameters(_ price: Double?, keyword: String?, size: String?, location: String?)
}

class SearchFilterViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: SearchFilterViewControllerDelegate?
    @IBOutlet weak var keywordsTextField: UITextField!
    @IBOutlet weak var priceBar: UISlider!
    
    @IBAction func priceBarChanged(_ sender: UISlider) {
        priceDouble = (Double(sender.value)*100).rounded()/100
        price.text = "\(priceDouble!)"
    }
    
    @IBOutlet weak var price: UILabel!
    
    var productKeyword: String?
    var priceDouble: Double?
    var productLocation: String?
    var productSize: String?
    
    
    @IBOutlet var locationTextField: UITextField!
    
    @IBOutlet weak var xsButton: UIButton!
    @IBOutlet weak var sButton: UIButton!
    @IBOutlet weak var mButton: UIButton!
    @IBOutlet weak var lButton: UIButton!
    @IBOutlet weak var xlButton: UIButton!
    
    @IBAction func xsPressed(_ sender: UIButton) {
        xsButton.layer.borderColor = UIColor.green.cgColor
        sButton.layer.borderColor = UIColor.gray.cgColor
        mButton.layer.borderColor = UIColor.gray.cgColor
        lButton.layer.borderColor = UIColor.gray.cgColor
        xlButton.layer.borderColor = UIColor.gray.cgColor
        productSize = "xSmall"
    }
    
    @IBAction func sPressed(_ sender: UIButton) {
        xsButton.layer.borderColor = UIColor.gray.cgColor
        sButton.layer.borderColor = UIColor.green.cgColor
        mButton.layer.borderColor = UIColor.gray.cgColor
        lButton.layer.borderColor = UIColor.gray.cgColor
        xlButton.layer.borderColor = UIColor.gray.cgColor
        productSize = "small"
    }
    
    @IBAction func mPressed(_ sender: UIButton) {
        xsButton.layer.borderColor = UIColor.gray.cgColor
        sButton.layer.borderColor = UIColor.gray.cgColor
        mButton.layer.borderColor = UIColor.green.cgColor
        lButton.layer.borderColor = UIColor.gray.cgColor
        xlButton.layer.borderColor = UIColor.gray.cgColor
        productSize = "medium"
    }
    
    @IBAction func lPressed(_ sender: UIButton) {
        xsButton.layer.borderColor = UIColor.gray.cgColor
        sButton.layer.borderColor = UIColor.gray.cgColor
        mButton.layer.borderColor = UIColor.gray.cgColor
        lButton.layer.borderColor = UIColor.green.cgColor
        xlButton.layer.borderColor = UIColor.gray.cgColor
        productSize = "large"
    }
    
    @IBAction func xlPressed(_ sender: UIButton) {
        xsButton.layer.borderColor = UIColor.gray.cgColor
        sButton.layer.borderColor = UIColor.gray.cgColor
        mButton.layer.borderColor = UIColor.gray.cgColor
        lButton.layer.borderColor = UIColor.gray.cgColor
        xlButton.layer.borderColor = UIColor.green.cgColor
        productSize = "xLarge"    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        keywordsTextField.delegate = self
        
        xsButton.layer.borderWidth = 1.5
        sButton.layer.borderWidth = 1.5
        mButton.layer.borderWidth = 1.5
        lButton.layer.borderWidth = 1.5
        xlButton.layer.borderWidth = 1.5
        
        xsButton.layer.borderColor = UIColor.gray.cgColor
        sButton.layer.borderColor = UIColor.gray.cgColor
        mButton.layer.borderColor = UIColor.gray.cgColor
        lButton.layer.borderColor = UIColor.gray.cgColor
        xlButton.layer.borderColor = UIColor.gray.cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if keywordsTextField.text != "" {
            productKeyword = keywordsTextField.text
        }
        if locationTextField.text != "" {
            productLocation = locationTextField.text
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let del = delegate {
            del.decidedParameters(priceDouble, keyword: productKeyword, size: productSize, location: productLocation)
        }
        super.viewWillDisappear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HI")
        if segue.identifier == "showTable" {
            print("HI")
        }
    }
}
