//
//  SearchViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/16/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIPopoverPresentationControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.lightGray
        button.setTitle("", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "funnel.png") , for: .normal)
        searchBar.showsCancelButton = true
        
        if let navBar = self.navigationController?.navigationBar  {
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: navBar.frame.height)
            let fontSize = 17
            let titleLabel = UILabel(frame: frame)
            titleLabel.text = "F I T B O O K"
            titleLabel.font = UIFont(name: "AvenirNext", size: CGFloat(fontSize))
            titleLabel.textAlignment = NSTextAlignment.center
            navBar.addSubview(titleLabel)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    var productKeyword: String?
    var includeSmall: Bool?
    var includeMedium: Bool?
    var includeLarge: Bool?
    var includeXSmall: Bool?
    var includeXLarge: Bool?
    var productLocation: String?
    var productPrice: Double?
    
    var mode: String?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        let exploreTableViewController = self.childViewControllers.last as? ExploreTableViewController
        
        switch sender.selectedSegmentIndex {
        case 0:
            exploreTableViewController?.mode = "sell"
        case 1:
            exploreTableViewController?.mode = ""
        case 2:
            exploreTableViewController?.mode = "buy"
        default:
            break
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func filterButton(_ sender: UIButton) {
        showPopover()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segmentedControl.selectedSegmentIndex = 1
        super.viewWillAppear(animated)
    }
    
    @IBOutlet weak var button: UIButton!
    
    func showPopover() {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "filterDetails") as? SearchFilterViewController
        let navController = UINavigationController(rootViewController: popoverContent!)
        navController.modalPresentationStyle = .popover
        let popover = navController.popoverPresentationController
        popoverContent?.preferredContentSize = CGSize(width: 300, height: 300)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: self.button.frame.origin.x, y: self.button.frame.origin.y, width: 300, height: 300)
        popoverContent?.delegate = self.childViewControllers.last as? ExploreTableViewController
        self.present(navController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let exploreTableViewController = self.childViewControllers.last as? ExploreTableViewController
        exploreTableViewController?.searchTerm = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
