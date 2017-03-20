//
//  UserPictureTableViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/11/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import CoreData

class UserPictureTableViewController: FetchedResultsTableViewController {
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet { updateUI() }
    }
    
    var fetchedResultsController: NSFetchedResultsController<Post>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    private func updateUI() {
        if let context = container?.viewContext {
            let defaults = UserDefaults.standard
            let request: NSFetchRequest<Post> = Post.fetchRequest()
            request.predicate = NSPredicate(format: "ownedBy.userID = [c]%@", defaults.string(forKey: "userID")!)
            request.sortDescriptors = [NSSortDescriptor(key: "postedDate", ascending: false)]
            fetchedResultsController = NSFetchedResultsController<Post>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        }
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userPictureCell", for: indexPath)
        if let post = fetchedResultsController?.object(at: indexPath) {
            if let singlePictureCell = cell as? SinglePictureTableViewCell {
                singlePictureCell.picture.image = UIImage(data: post.photo! as Data, scale: 1.0)
                let dateDescription = post.postedDate?.description
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let dateObj = dateFormatter.date(from: dateDescription!)
                dateFormatter.dateFormat = "MMM d, yyyy"
                singlePictureCell.desc.text = "\(dateFormatter.string(from: dateObj!))\n\((post.caption)!)"
                singlePictureCell.post = post
                let detailsGesture = UILongPressGestureRecognizer(target: self, action: #selector(pressed(byReactingTo:)))
                singlePictureCell.addGestureRecognizer(detailsGesture)
            }
        }
        return cell
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
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            if let context = container?.viewContext {
//                if let post = fetchedResultsController?.object(at: indexPath) {
//                    context.delete(post)
//                    do {
//                        try context.save()
//                    } catch let error as NSError {
//                        print("Could not save due to \(error)")
//                    }
//                    tableView.reloadData()
//                    printDatabaseStatistics()
//                }
//            }
//        }
//    }
}
