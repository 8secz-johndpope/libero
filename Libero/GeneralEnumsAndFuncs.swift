//
//  GeneralEnumsAndFuncs.swift
//  Libero
//
//  Created by John Kotz on 10/17/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation

enum BackendError {
    enum User {
        enum SignUp {
            case UsernameExists
            case PasswordInvalid
        }
        enum Login {
            case UnknownLogin
        }
    }
    case FailedToConnect
    case FailedToSave
    case DataDoesntExist
    case Warrior
    case Knight
}
