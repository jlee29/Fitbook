//
//  FilterViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/13/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import CoreImage

protocol FilterViewControllerDelegate {
    func changedImage(_ image: UIImage)
}

class FilterViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    var inputImage: UIImageView? {
        didSet {
            preFilterImage = CIImage(image: (inputImage?.image)!)
        }
    }
    
    var preFilterImage: CIImage? {
        didSet {
            print ("set pre filter image")
        }
    }
    
    private let filterDict: Dictionary<String,String> =
    [
    "Mono": "CIColorMonochrome",
    "Vignette": "CIVignette",
    "Sepia": "CISepiaTone",
    "Pixellate": "CIPixellate",
    "Invert": "CIColorInvert"
    ]
    
    var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        let sepiaFilter = CIFilter(name: "CISepiaTone")
//        sepiaFilter?.setValue(preFilterImage, forKey: kCIInputImageKey)
//        sepiaFilter?.setValue(0.5, forKey: kCIInputIntensityKey)
//        
        image.image = inputImage?.image
//
//        button1.setBackgroundImage(UIImage(ciImage: (sepiaFilter?.outputImage)!), for: .normal)

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    var filter: CIFilter?
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        if filter != nil {filter?.setValue(preFilterImage, forKey: kCIInputImageKey)
            filter?.setValue(sender.value, forKey: kCIInputIntensityKey)
            let context = CIContext(options: nil)
            let cgImg = context.createCGImage((filter?.outputImage)!, from: (filter?.outputImage)!.extent)
            image.image = UIImage(cgImage: cgImg!)
            
        }
    }
    
    @IBAction func buttonPress(_ sender: UIButton) {
        if sender.titleLabel?.text == "Invert" || sender.titleLabel?.text == "Pixellate" {
            slider.isHidden = true
        } else {
            slider.isHidden = false
        }
        let filterTitle = filterDict[(sender.titleLabel?.text)!]
        filter = CIFilter(name: filterTitle!)!
        filter?.setValue(preFilterImage, forKey: kCIInputImageKey)
        let context = CIContext(options: nil)
        let cgImg = context.createCGImage((filter?.outputImage)!, from: (filter?.outputImage)!.extent)
        image.image = UIImage(cgImage: cgImg!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let del = delegate {
            del.changedImage(image.image!)
        }
        super.viewWillDisappear(animated)
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
