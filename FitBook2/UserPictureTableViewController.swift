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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
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
            request.sortDescriptors = [NSSortDescriptor(key: "numLikes", ascending: false)]
            fetchedResultsController = NSFetchedResultsController<Post>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        }
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userPictureCell", for: indexPath)
        if let post = fetchedResultsController?.object(at: indexPath) {
            if let singlePictureCell = cell as? SinglePictureTableViewCell {
                singlePictureCell.picture.image = UIImage(data: post.photo! as Data, scale: 1.0)
            }
        }
        return cell
    }
}
