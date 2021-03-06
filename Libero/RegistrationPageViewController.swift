//
//  RegistrationPageViewController.swift
//  Libero
//
//  Created by Nitasha Kochar on 10/30/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import SCLAlertView

class RegistrationPageViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        usernameTextfield.resignFirstResponder()
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        confirmPasswordTextfield.resignFirstResponder()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showNextTextFeild(_ sender: UITextField) {
        switch sender {
        case self.usernameTextfield:
            emailTextfield.becomeFirstResponder()
            break
            
        case self.emailTextfield:
            passwordTextfield.becomeFirstResponder()
            break
            
        case passwordTextfield:
            confirmPasswordTextfield.becomeFirstResponder()
            break
            
        case confirmPasswordTextfield:
            self.registerButton(sender)
            break
        default:
            return
        }
    }
    
    
    @IBAction func registerButton(_ sender: AnyObject) {
        guard let username = usernameTextfield.text, username != "" else {
            let alert = SCLAlertView()
            alert.showError("Incomplete", subTitle: "Please enter a username.")
            return
        }
        guard let email = emailTextfield.text, email != "" else {
            let alert = SCLAlertView()
            alert.showError("Incomplete", subTitle: "Please enter an e-mail address.")
            return
        }
        guard let password = passwordTextfield.text, password != "" else {
            let alert = SCLAlertView()
            alert.showError("Incomplete", subTitle: "Please enter a password.")
            return
        }
        guard let password2 = confirmPasswordTextfield.text, password2 != "" else {
            let alert = SCLAlertView()
            alert.showError("Incomplete", subTitle: "Please confirm password.")
            return
        }
        
        if password != password2{
            let alert = SCLAlertView()
            alert.showError("Inconsistent", subTitle:"Please make sure your passwords match.")
            return
            
        }
        
        if !User.isValidEmail(email){
            let alert = SCLAlertView()
            alert.showError("Invalid", subTitle: "Please enter a valid e-mail address.")
            return
        }
        
//        if username == ""{
//            return
//        }
        
        User.signUp(withUsername: username, andPassword: password, block: { (user, error) in
            if let user = user {
                //perform segue
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                if user.completedSetup || AppDelegate.shouldSkipSurvey() {
                    let tabVC = mainStoryboard.instantiateViewController(withIdentifier: "tabController")
                    self.present(tabVC, animated: true, completion: nil)
                }
                else {
                    let navVC = mainStoryboard.instantiateViewController(withIdentifier: "formerNav") as! UINavigationController
                    self.present(navVC, animated: true, completion: nil)
                    
                }
            }
            
            else {
                //if user can't make an account for some reason
                let alert = SCLAlertView()
                alert.showError("Unable to Register", subTitle: "Account can not be created at this time.")
            }
            
        })
        
        
        
    }
    
    
    @IBAction func goToLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
