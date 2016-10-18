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
    static func parseClassName() -> String {
        return "Achievement"
    }
}
