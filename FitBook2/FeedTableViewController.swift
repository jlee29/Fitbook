//
//  FeedTableViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/6/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class FeedTableViewController: FetchedResultsTableViewController {
    
    var audioPlayer = AVAudioPlayer()
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet { updateUI() }
    }
    
    var fetchedResultsController: NSFetchedResultsController<Grouping>?
    
    private func updateUI() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<Grouping> = Grouping.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "numPics", ascending: false)]
            fetchedResultsController = NSFetchedResultsController<Grouping>(
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if let navBar = self.navigationController?.navigationBar  {
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: navBar.frame.height)
            let fontSize = 17
            let titleLabel = UILabel(frame: frame)
            titleLabel.text = "F I T B O O K"
            titleLabel.font = UIFont(name: "AvenirNext", size: CGFloat(fontSize))
            titleLabel.textAlignment = NSTextAlignment.center
            navBar.addSubview(titleLabel)
        }
        tableView.separatorStyle = .none
        
        
        let music = Bundle.main.url(forResource: "likeSound", withExtension: "wav")!
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: music)
            audioPlayer.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        DispatchQueue.main.async {
            self.updateUI()
        }
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func liked(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if let currCell = tapRecognizer.view as? PictureTableViewCell {
            if tapRecognizer.location(in: view).x <= view.frame.width/2 {
                currCell.leftPost?.numLikes += 1
                showHeartAndPlaySound()
            } else {
                if currCell.rightPost != nil {
                    currCell.rightPost?.numLikes += 1
                    showHeartAndPlaySound()
                }
            }
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
    
    func tapped(byReactingTo pressRecognizer: UILongPressGestureRecognizer) {
        if let currCell = pressRecognizer.view as? PictureTableViewCell {
            if pressRecognizer.state == .began {
                let storyboard = self.storyboard!
                let controller = storyboard.instantiateViewController(withIdentifier: "details")
                if let detailsController = controller as? DetailsViewController {
                    if pressRecognizer.location(in: view).x <= view.frame.width/2 {
                        detailsController.post = currCell.leftPost
                    } else {
                        detailsController.post = currCell.rightPost
                    }
                    if detailsController.post != nil {
                        self.navigationController?.pushViewController(detailsController, animated: true)
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath)
        if let grouping = fetchedResultsController?.object(at: indexPath) {
            if grouping.type == "small" {
                if let pictureCell = cell as? PictureTableViewCell {
                    let leftPost = grouping.leftPost
                    let rightPost = grouping.rightPost
                    pictureCell.leftPost = leftPost
                    pictureCell.leftPicture.image = UIImage(data: leftPost?.photo as! Data)
                    print(grouping.numPics)
                    if grouping.numPics > 1 {
                        pictureCell.rightPost = rightPost
                        pictureCell.rightPicture.image = UIImage(data: rightPost?.photo as! Data)
                    } else {
                        pictureCell.rightPicture.image = nil
                    }
                    let likeGesture = UITapGestureRecognizer(target: self, action: #selector(liked(byReactingTo:)))
                    likeGesture.numberOfTapsRequired = 1
                    cell.addGestureRecognizer(likeGesture)
                    let detailsGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapped(byReactingTo:)))
                    cell.addGestureRecognizer(detailsGesture)
                }
                return cell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "bigPictureCell", for: indexPath)
                if let bigPictureCell = cell as? BigPictureTableViewCell {
                    let post = grouping.leftPost
                    
                    let frameWidth = bigPictureCell.bigPicture.frame.width
                    let frameHeight = bigPictureCell.bigPicture.frame.height
                    
                    let picWidth = UIImage(data: post?.photo as! Data, scale: 1.0)?.size.width
                    let picHeight = UIImage(data: post?.photo as! Data, scale: 1.0)?.size.height
                    let scale = frameWidth/picWidth! > frameHeight/picHeight! ? frameHeight/picHeight! : frameWidth/picWidth!
                    bigPictureCell.bigPicture.image = UIImage(data: post?.photo as! Data, scale: scale)
                }
                return cell
            }
        }
        return cell
    }
}
