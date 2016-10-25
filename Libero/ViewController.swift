//
//  ViewController.swift
//  Libero
//
//  Created by John Kotz on 9/30/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        User.loginWithFacebook { (user, error) in
            print("User: \(user) with id: \(user?.objectId)")
            print("Error: \(error)")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

