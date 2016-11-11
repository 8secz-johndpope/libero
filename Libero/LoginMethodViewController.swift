//
//  LoginMethodViewController.swift
//  Libero
//
//  Created by John Kotz on 11/11/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import UIKit

class LoginMethodViewController: UIViewController {
    @IBAction func facebookLoginPressed(_ sender: UIButton) {
        User.loginWithFacebook { (user, error) in
            if let user = user {
                //do segue, allow them to enter app
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                if user.completedSetup {
                    let tabVC = mainStoryboard.instantiateViewController(withIdentifier: "tabController")
                    self.present(tabVC, animated: true, completion: nil)
                }
                else {
                    let formerVC = mainStoryboard.instantiateViewController(withIdentifier: "formerNav")
                    self.present(formerVC, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
}
