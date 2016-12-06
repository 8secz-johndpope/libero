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
    @NSManaged private var myType: String
    
    var type: TypeEnum {
        get {
            return TypeEnum(rawValue: self.myType) ?? .unknown
        }
        set {
            myType = newValue.rawValue
        }
    }
    
    override init() {
        super.init()
        self.name = ""
        self.myType = ""
    }
    
    init(name: String, type: TypeEnum) {
        super.init()
        self.name = name
        self.type = type
    }
    
    static func parseClassName() -> String {
        return "Achievement"
    }
    
    
    enum TypeEnum: String {
        case first
        case second
        case third
        case fourth
        case unknown
    }
}
