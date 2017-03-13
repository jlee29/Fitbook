//
//  User.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/5/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import CoreData

class User: NSManagedObject {
//    
    class func findOrCreateUser(matching userID: String, name realname: String, in context: NSManagedObjectContext) throws -> User {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userID = %@", userID)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "User.findOrCreateUser -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let user = User(context: context)
        user.userID = userID
        user.realname = realname
        return user
    }
    
    class func findUser(matching userID: String, in context: NSManagedObjectContext) throws -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userID = %@", userID)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "User.findUser -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        return nil
    }


}
