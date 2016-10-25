//
//  Legus.swift
//  Libero
//
//  Created by John Kotz on 10/17/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import Parse

class League: PFObject, PFSubclassing {
    @NSManaged var name: String
    private var members: [User]? = []
    
    func initialize() {
        self.loadMembers() { (_, _) in}
    }
    
    /**
     Gets all the users in the legue and stores them locally for operations
     */
    func loadMembers(with block: ((_ members: [User]?, _ error: Error?) -> Void)?) {
        let relation = self.relation(forKey: "members")
        relation.query().findObjectsInBackground { (objects, error) in
            let objects = objects as? [User]
            
            self.members = objects
            if let block = block {
                block(objects, nil)
            }
        }
    }
    
    func getLeaderBoard(with block: @escaping ([User]?, BackendError?) -> Void) {
        let relation = self.relation(forKey: "members")
        let query = relation.query()
        query.addDescendingOrder("numWorkouts")
        query.findObjectsInBackground { (objects, error) in
            if let _ = error {
                block(nil, BackendError.UnknownError)
            }else{
                block(objects as? [User], nil)
            }
        }
    }
    
    static func parseClassName() -> String {
        return "Legue"
    }
}
