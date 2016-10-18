//
//  Legus.swift
//  Libero
//
//  Created by John Kotz on 10/17/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import Parse

class Legue: PFObject, PFSubclassing {
    @NSManaged var name: String
    private var members: [User]? = []
    
    override init() {
        super.init()
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
    
    
    static func parseClassName() -> String {
        return "Legue"
    }
}
