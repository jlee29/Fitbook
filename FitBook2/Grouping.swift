//
//  Grouping.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/6/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import CoreData

class Grouping: NSManagedObject {
    class func findAvailableGroupingOrCreateGrouping(in context: NSManagedObjectContext) throws -> Grouping {
        let request: NSFetchRequest<Grouping> = Grouping.fetchRequest()
        request.predicate = NSPredicate(format: "numPics = 1 and type = %@", "small")
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Grouping.findOrCreateUser -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        let grouping = Grouping(context: context)
        grouping.type = "small"
        grouping.numPics = 0
        return grouping
    }
    
    class func createBigGrouping(in context: NSManagedObjectContext) throws -> Grouping {
        let grouping = Grouping(context: context)
        grouping.numPics = 1
        grouping.type = "big"
        return grouping
    }
}
