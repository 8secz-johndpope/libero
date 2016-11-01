//
//  LoginPageViewController.swift
//  Libero
//
//  Created by Nitasha Kochar on 10/23/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import SCLAlertView

class LoginPageViewController: UIViewController {
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        let username = usernameTextfield.text!
        let password = passwordTextfield.text!
        
        //if username or password or both are empty
        if username.isEmpty || passwordTextfield.text!.isEmpty {
            let alert = SCLAlertView()
            alert.showError("Incomplete", subTitle: "Please input a username and passworld")
            
            // reset textfields
            usernameTextfield.text = nil
            passwordTextfield.text = nil
            
        } else {
            //if user able to login
            User.login(withUsername: username, andPassword: password) { (user, error) in
                if let user = user {
                    
                    //do segue, allow them to enter app
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabVC = mainStoryboard.instantiateViewController(withIdentifier: "tabController")
                    self.present(tabVC, animated: true, completion: nil)
                    
                    if !user.completedSetup {
                        tabVC.performSegue(withIdentifier: "showSurvey", sender: nil)
                    }
                }
                    
                else {
                    //if user does not exist/information inaccurate
                    let alert = SCLAlertView()
                    alert.showError("Incorrect", subTitle: "Username or password is incorrect.")
                    
                    //reset textfields
                    self.usernameTextfield.resignFirstResponder()
                    self.passwordTextfield.resignFirstResponder()
                    self.usernameTextfield.text = ""
                    self.passwordTextfield.text = ""
                    
                    
                }
            }
            

            /*
             // MARK: - Navigation
             
             // In a storyboard-based application, you will often want to do a little preparation before navigation
             override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             // Get the new view controller using segue.destinationViewController.
             // Pass the selected object to the new view controller.
             }
             */
            
        }
    }
}
