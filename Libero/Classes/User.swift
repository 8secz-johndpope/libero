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
    class ProfilePic: PFObject, PFSubclassing {
        @NSManaged var file: PFFile
        
        static func parseClassName() -> String {
            return "ProfilePic"
        }
    }
    
    // Commented are ones in by default
    // email: String?
    // password: String?
    // username: String
    @NSManaged var emailVerified: Bool
    @NSManaged var completedSetup: Bool
    @NSManaged var league: League?
    @NSManaged var picture: ProfilePic?
    @NSManaged var activeWorkout: Workout?
    var pictureURL: String? {
        return self.picture?.file.url
    }
    
    var pastWorkouts: [Workout]?
    var achievements: [Achievement]?
    var friends: [User]?
    
    /**
     Loads a number of the objects stored in the User
     */
    func initialize(_ block: @escaping (User) -> Void) {
        var done = 0
        let todo = 6
        func dealWithComplete() {
            done += 1
            
            if done >= todo {
                block(self)
            }
        }
        
        self.relation(forKey: "pastWorkouts").query().findObjectsInBackground { (objects, error) in
            if let objects = objects as? [Workout] {
                self.pastWorkouts = objects
            }
            dealWithComplete()
        }
        
        self.relation(forKey: "achievements").query().findObjectsInBackground { (objects, error) in
            if let objects = objects as? [Achievement] {
                self.achievements = objects
            }
            dealWithComplete()
        }
        
        self.relation(forKey: "friends").query().findObjectsInBackground { (objects, error) in
            if let objects = objects as? [User] {
                self.friends = objects
            }
            dealWithComplete()
        }
        
        league?.fetchInBackground(block: { (object, error) in
            dealWithComplete()
        })
        
        picture?.fetchInBackground(block: { (object, error) in
            dealWithComplete()
        })
        
        activeWorkout?.fetchInBackground(block: { (object, erro) in
            dealWithComplete()
        })
    }
    
    // ========= User Functions ==========
    
    func addWorkout(workout: Workout) {
        if workout.isActive {
            self.activeWorkout = workout
        }else{
            self.relation(forKey: "pastWorkouts").add(workout)
            self.pastWorkouts?.append(workout)
        }
        
        self.saveInBackground { (success, error) in
            PFCloud.callFunction(inBackground: "updateWorkouts", withParameters: ["user": self])
        }
    }
    
    
    // ========= Static Functions ==========
    
    /**
     Standard login with email and password
     
     - parameter username: The user's username
     - parameter password: The user's password
     
     - parameter block: The callback after the login is finished (if login succeeds, user object will not be nil, and otherwise the error will describe why it failed)
     */
    static func login(withUsername username: String, andPassword password: String, block: @escaping (User?, BackendError?) -> Void) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if let user = user as? User, error == nil {
                user.initialize({ (user) in
                    DispatchQueue.main.async {
                        block(user, nil)
                    }
                })
            }else{
                DispatchQueue.main.async {
                    if let error = error {
                        var retError: BackendError! = nil
                        
                        switch error._code {
                        case 205:
                            retError = BackendError.User.Login.UnknownLogin
                            break
                            
                        default:
                            retError = BackendError.User.Login.UnknownLogin
                        }
                        
                        block(nil, retError)
                    }
                }
            }
        }
    }
    
    /**
     This will open a modal with which a user can sign in
     
     NOTE: This is untested
     - parameter block: A callback that will be executed on completion (when they login and the modal disapears) with the user and an error if there is one
     */
    static func loginWithFacebook(block: @escaping (User?, BackendError?) -> Void) {
        let permissionsArray = ["email"];
        
        
        PFFacebookUtils.setFacebookLoginBehavior(.useSystemAccountIfPresent)
        PFFacebookUtils.logIn(withPermissions: permissionsArray) { (user, error) in
            if let user = user as? User, error == nil {
                user.initialize({ (user) in
                    block(user, nil)
                })
            }else{
                block(nil, BackendError.User.Login.UnknownLoginError)
            }
        }
    }
    
    /**
     Signs the user up with the given email and password, and gets the server to choose an image
     
     - parameter username: The username the person has chosen
     - parameter password: The user's password
     - parameter block: A callback that returns the user and error if there is one
     */
    static func signUp(withUsername username: String, andPassword password: String, block: @escaping (User?, BackendError?) -> Void) {
        let user = User()
        user.username = username
        user.password = password
        user.emailVerified = false
        user.completedSetup = false
        user.pastWorkouts = []
        user.achievements = []
        user.league = nil
        
        user.signUpInBackground { (success, error) in
            if let error = error {
                var retError: BackendError! = nil
                
                switch error._code {
                case 125: // Invalid username
                    retError = BackendError.User.SignUp.InvalidUsername
                    break
                    
                case 202: // The username already exists
                    retError = BackendError.User.SignUp.UsernameExists
                    break
                    
                default:
                    retError = BackendError.UnknownError
                }
                
                block(nil, retError)
                return
            }else if !success {
                block(nil, BackendError.UnknownError)
                return
            }
            
            user.initialize({ (user) in
                block(user, nil)
            })
        }
    }
    
    func finishSignUp(survey: SurveyResponse, block: @escaping (BackendError?) -> Void) {
        PFCloud.callFunction(inBackground: "onSignUp", withParameters: ["user": self.objectId, "survey": ["frequency":survey.frequency.rawValue, "intensity": survey.intensity.rawValue]], block: { (result, error) in
            self.fetchInBackground(block: { (_, error2) in
                if error != nil || error2 != nil {
                    block(BackendError.ServerError.CloudCodeFailed)
                }else{
                    block(nil)
                }
            })
        });
    }
    
    static func requestPasswordReset(forEmail email:String, block: @escaping (_ error: BackendError.User.PasswordReset?) -> Void) {
        PFUser.requestPasswordResetForEmail(inBackground: email) { (success, error) in
            if let error = error {
                print("Error \(error._code): \(error.localizedDescription)")
                block(BackendError.User.PasswordReset.UnknownPasswordResetError)
            }
        }
    }
    
    static var isLoggedIn: Bool {
        return PFUser.current() != nil
    }
    
    static func logout(block: PFUserLogoutResultBlock?) {
        PFUser.logOutInBackground(block: block)
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // ========= End Static Functions ==========
    
    class SurveyResponse {
        var frequency: Frequency!
        var intensity: Intensity!
        
        init(frequency: Frequency, intensity: Intensity) {
            self.frequency = frequency
            self.intensity = intensity
        }
        
        enum Frequency: String {
            case LessThanOnce
            case Once
            case TwoThree
            case FourPlus
        }
        
        enum Intensity: Int {
            case Beginner = 0
            case Intermediate = 1
            case Advanced = 2
            case Enthusiast = 3
        }
    }
}
