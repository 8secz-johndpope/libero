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
    static let grey = UIColor(hexString: "#383838")
    
    
    class func setUpNavBar(navBar: UINavigationBar) {
        navBar.barTintColor = L.grey
        navBar.isTranslucent = true
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size:20)!, NSForegroundColorAttributeName: UIColor.white]
    }
}
