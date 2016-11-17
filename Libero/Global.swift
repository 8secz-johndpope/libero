//
//  Global.swift
//  Libero
//
//  Created by Nitasha Kochar on 11/13/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors

class L {
    
    static let yellow = UIColor(hexString: "#FFF100")
    static let grey = UIColor(hexString: "#222121")
    
    
    class func setUpNavBar(navBar: UINavigationBar) {
        navBar.barTintColor = L.grey
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Black", size:20)!, NSForegroundColorAttributeName: UIColor.white]
    }
}
