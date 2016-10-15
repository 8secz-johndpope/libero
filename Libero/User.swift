//
//  User.swift
//  Libero
//
//  Created by John Kotz on 10/14/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import Parse
import ParseFacebookUtils

class User: PFUser {
    // Commented are ones in by default
    // email: String?
    // password: String?
    // username: String
    @NSManaged var emailVerified: Bool
    
    
    
    
    static func login(email: String, password: String, block: @escaping (_ user: User?, _ error: Error?) -> Void) {
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            if let user = user as? User, error == nil {
                DispatchQueue.main.async {
                    block(user, nil)
                }
            }else{
                DispatchQueue.main.async {
                    block(nil, error)
                }
            }
        }
    }

    // Not supported yet
//    static func loginWithGoogle() {
//        
//    }
    
    static func loginWithFacebook(block: @escaping (_ user: User?, _ error: Error?) -> Void) {
        let permissionsArray = ["user_birthday"];
        
        PFFacebookUtils.logIn(withPermissions: permissionsArray) { (user, error) in
            if let user = user as? User, error == nil {
                block(user, nil)
            }else{
                block(nil, error)
            }
        }
    }
    
    static var isLoggedIn: Bool {
        get {
            return PFUser.current() != nil
        }
        set {}
    }
    
    static func logout(block: PFUserLogoutResultBlock?) {
        PFUser.logOutInBackground(block: block)
    }
}
