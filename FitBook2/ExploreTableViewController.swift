//
//  ExploreTableViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/11/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ExploreTableViewController: FetchedResultsTableViewController, SearchFilterViewControllerDelegate {
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet { updateUI(with: nil, mode: modePredicate) }
    }
    var audioPlayer = AVAudioPlayer()
    
    var keyword: String? {
        didSet {
            print("set \(keyword)")
        }
    }
    
    var price: Double? {
        didSet {
            print("set price to be \(price)")
        }
    }
    
    var location: String? {
        didSet {
            print("location is \(location)")
        }
    }
    
    var modePredicate: NSPredicate?
    
    var mode: String? {
        didSet {
            currPredicate = nil
            if mode! != "" {
                modePredicate = NSPredicate(format: "wantToSellOrBuy = %@", mode!)
            } else {
                modePredicate = NSPredicate(format: "numLikes > -1")
            }
            updateUI(with: nil, mode: modePredicate)
        }
    }
    
    var searchTerm: String? {
        didSet {
            if searchTerm != nil, searchTerm! != "" {
                let searchPredicate = NSPredicate(format: "caption contains %@", searchTerm!)
                updateUI(with: searchPredicate, mode: modePredicate)
            }
        }
    }
    
    var pricePredicate: NSPredicate?
    var keywordPredicate: NSPredicate?
    var sizePredicate: NSPredicate?
    var xsmallPredicate: NSPredicate?
    var smallPredicate: NSPredicate?
    var mediumPredicate: NSPredicate?
    var largePredicate: NSPredicate?
    var xlargePredicate: NSPredicate?
    var locationPredicate: NSPredicate?
    var currPredicate: NSPredicate?
    
    func decidedParameters(_ price: Double?, keyword: String?, size: String?, location: String?) {
        currPredicate = NSPredicate(format: "numLikes > -1")
        if price != nil {
            pricePredicate = NSPredicate(format: "price <= \(price!)")
            currPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currPredicate!, pricePredicate!])
        }
        if keyword != nil {
            keywordPredicate = NSPredicate(format: "caption contains %@", keyword!)
            currPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currPredicate!, keywordPredicate!])
        }
        if size != nil {
            sizePredicate = NSPredicate(format: "productSize = %@", size!)
            currPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currPredicate!, sizePredicate!])
        }
        if location != nil {
            locationPredicate = NSPredicate(format: "location == %@", location!)
            currPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currPredicate!, locationPredicate!])
        }
        updateUI(with: currPredicate, mode: modePredicate)
    }

    var fetchedResultsController: NSFetchedResultsController<Post>?
    
    private func updateUI(with predicates: NSPredicate?, mode modePredicate: NSPredicate?) {
        if let context = container?.viewContext {
            let request: NSFetchRequest<Post> = Post.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "numLikes", ascending: false)]
            if predicates == nil {
                request.predicate = modePredicate
            } else {
                if currPredicate != nil {
                    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicates!, currPredicate!, modePredicate!])
                } else {
                    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicates!, modePredicate!])
                }
            }
            fetchedResultsController = NSFetchedResultsController<Post>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        }
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        let music = Bundle.main.url(forResource: "likeSound", withExtension: "wav")!
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: music)
            audioPlayer.prepareToPlay()
        }
        catch {
            print(error)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mode = ""
        updateUI(with: nil, mode: modePredicate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pressed(byReactingTo pressRecognizer: UILongPressGestureRecognizer) {
        if let currCell = pressRecognizer.view as? SinglePictureTableViewCell {
            if pressRecognizer.state == .began {
                let storyboard = self.storyboard!
                let controller = storyboard.instantiateViewController(withIdentifier: "details")
                if let detailsController = controller as? DetailsViewController {
                    detailsController.post = currCell.post
                    self.navigationController?.pushViewController(detailsController, animated: true)
                }
            }
        }
    }
    
    func liked(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if let currCell = tapRecognizer.view as? SinglePictureTableViewCell {
            currCell.post?.numLikes += 1
            showHeartAndPlaySound()
//            if tapRecognizer.location(in: view).x <= view.frame.width/2 {
//                currCell.leftPost?.numLikes += 1
//                showHeartAndPlaySound()
//            } else {
//                if currCell.rightPost != nil {
//                    currCell.rightPost?.numLikes += 1
//                    showHeartAndPlaySound()
//                }
//            }
        }
    }
    
    func showHeartAndPlaySound() {
        audioPlayer.play()
        let heart = HeartView(frame: self.view.bounds)
        heart.backgroundColor = UIColor.clear
        self.view.addSubview(heart)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            heart.alpha = 1.0
        }, completion: {
            (finished: Bool) -> Void in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                heart.alpha = 0.0
            }, completion: nil)
        })
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singlePictureCell", for: indexPath)
        if let post = fetchedResultsController?.object(at: indexPath) {
            if let singlePictureCell = cell as? SinglePictureTableViewCell {
                singlePictureCell.picture.image = UIImage(data: post.photo! as Data, scale: 1.0)
                singlePictureCell.userAndLikes.text = "\((post.ownedBy?.realname)!) ❤️: \(post.numLikes)"
                singlePictureCell.desc.text = "\(post.caption!)"
                singlePictureCell.post = post
                let likeGesture = UITapGestureRecognizer(target: self, action: #selector(liked(byReactingTo:)))
                likeGesture.numberOfTapsRequired = 1
                cell.addGestureRecognizer(likeGesture)
                let detailsGesture = UILongPressGestureRecognizer(target: self, action: #selector(pressed(byReactingTo:)))
                cell.addGestureRecognizer(detailsGesture)
            }
        }
        return cell
    }
}
