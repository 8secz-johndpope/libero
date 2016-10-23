//
//  Achievement.swift
//  Libero
//
//  Created by John Kotz on 10/16/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import Parse

class Achievement: PFObject, PFSubclassing {
    @NSManaged var name: String
    
    
    static func calculateAchievements(user: User) {
        // TODO: write achievements cloud function
        PFCloud.callFunction(inBackground: "calculateAchievements", withParameters: ["user": user.objectId]) { (result, error) in
            // TODO: deal with result
        }
    }
    
    static func parseClassName() -> String {
        return "Achievement"
    }
}
