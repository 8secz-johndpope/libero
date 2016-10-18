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
    @NSManaged var pastWorkouts: [Workout]
    @NSManaged var achievements: [Achievement]
    @NSManaged var legue: Legue?
    @NSManaged var picture: PFFile?
    
    
    /**
     Standard login with email and password
     
     - parameter username: The user's username
     */
    static func login(withUsername username: String, andPassword password: String, block: @escaping PFUserResultBlock) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
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
    
    /**
     This will open a modal with which a user can sign in
     
     NOTE: This is untested
     - parameter block: A callback that will be executed on completion (when they login and the modal disapears) with the user and an error if there is one
     */
    static func loginWithFacebook(block: @escaping PFUserResultBlock) {
        let permissionsArray = ["user_birthday"];
        
        PFFacebookUtils.logIn(withPermissions: permissionsArray) { (user, error) in
            if let user = user as? User, error == nil {
                block(user, nil)
            }else{
                block(nil, error)
            }
        }
    }
    
    /**
     Signs the user up with the given email and password, and gets the server to choose an image
     
     - parameter username: The username the person has chosen
     - parameter password: The user's password
     - parameter block: A callback that returns the user and error if there is one
     */
    static func signUp(withUsername username: String, andPassword password: String, block: @escaping PFUserResultBlock) {
        let user = User()
        user.username = username
        user.password = password
        user.emailVerified = false
        user.pastWorkouts = []
        user.achievements = []
        // TODO: Decide on the method we will use for placing in Legues?
        user.legue = nil
        
        user.signUpInBackground { (success, error) in
            // TODO: Write the function on the server and put its name here
            PFCloud.callFunction(inBackground: "", withParameters: ["user": user], block: { (result, error) in
                
            })
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
