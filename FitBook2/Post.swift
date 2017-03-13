//
//  Post.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/5/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import CoreData

class Post: NSManagedObject {
    class func createPost(by userID: String, with desc: String, in context: NSManagedObjectContext) throws -> Post {
        let post = Post(context: context)
        post.ownedBy = try? User.findUser(matching: userID, in: context)!
        post.caption = desc
        post.numLikes = 2
        return post
    }
    
//    class func findPostByHashtag(by hashtag: Hashtag) {
//        
//    }
}
