//
//  ProfileSettingsViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/15/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.lightGray
        self.view.layer.cornerRadius = 5
        self.view.layer.borderWidth = 1.0
        self.view.layer.borderColor = UIColor.black.cgColor
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height*4)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        let button2 = UIButton(type: .custom)
        button2.frame = CGRect(x: 0, y: scrollView.frame.height*4-100, width: 100, height: 100)
        button2.setTitle("YE", for: .normal)
        let yeImage = UIImage(named: "yeButton.jpg")
        button2.contentMode = .scaleAspectFit
        button2.setImage(yeImage, for: .normal)
        button2.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        scrollView.addSubview(button2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // cite this
        if scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < scrollView.frame.width {
            scrollView.contentOffset.x = 0
        }
    }
    
    func buttonPressed(sender: UIButton!) {
        let storyboard = self.storyboard!
        let gameController = storyboard.instantiateViewController(withIdentifier: "game")
        self.navigationController!.pushViewController(gameController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if let viewController = destinationViewController as? ViewController {
            viewController.logout()
            self.view.window!.rootViewController = viewController
        }
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
