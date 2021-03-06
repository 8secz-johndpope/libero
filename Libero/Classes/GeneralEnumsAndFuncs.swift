//
//  GeneralEnumsAndFuncs.swift
//  Libero
//
//  Created by John Kotz on 10/17/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation

//enum BackendError: Error {
//    enum User: Error {
//        enum SignUp: Error {
//            case UsernameExists
//            case InvalidUsername
//        }
//        enum Login: Error {
//            case UnknownLogin
//        }
//    }
//    case FailedToConnect
//    case FailedToSave
//    case DataDoesntExist
//    case UnknownError
//}

// I started with the enumeration method above, but I really wanted subclassing

class BackendError: Error, CustomStringConvertible {
    
    // This is a messy way to make an enumeration, but this way I get to make subclasses of the error
    class User: BackendError {
        // Some of the overall errors
        static let UnknownUserError = User("unknown_user_error")
        
        // Errors occured when signing up
        class SignUp: BackendError.User {
            static let UsernameExists: SignUp = SignUp("username_exists")
            static let InvalidUsername: SignUp = SignUp("invalid_username")
            
            override init(_ val: String) {
                // The ending value will be "Backend Error: user-signup-\(val)"
                super.init("signup-\(val)")
            }
        }
        
        // Errors occured when logging in
        class Login: BackendError.User {
            static let UnknownLogin = Login("unknown_login")
            static let UnknownLoginError = Login("unknown_error")
            
            override init(_ val: String) {
                // The ending value will be "Backend Error: user-login-\(val)"
                super.init("login-\(val)")
            }
        }
        
        // Errors occured when resetting password
        class PasswordReset: BackendError.User {
            static let UnknownPasswordResetError = PasswordReset("unknown_error (we should figure out what the error codes are)")
            
            override init(_ val: String) {
                super.init("passwdReset-\(val)")
            }
        }
        
        // This will give a printable value to the error
        override init(_ val: String) {
            // This will make a list of types in the value
            super.init("user-\(val)")
        }
    }
    class ServerError: BackendError {
        static let CloudCodeFailed = User("cloud_code_failed")
        
        override init(_ val: String) {
            // The ending value will be "Backend Error: signup-\(val)"
            super.init("signup-\(val)")
        }
    }
    static let FailedToConnect: BackendError = BackendError("failed_to_connect")
    static let FailedToSave: BackendError = BackendError("failed_to_save")
    static let DataDoesntExist: BackendError = BackendError("data_doesnt_exist")
    static let UnknownError: BackendError = BackendError("unknown_error")
    
    let raw_value: String
    init(_ val: String) {
        self.raw_value = val
    }
    
    var description: String {
        return "Backend Error: \(raw_value)"
    }
}
