//
//  SurveyViewController.swift
//  Libero
//
//  Created by Nitasha Kochar on 10/30/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import SCLAlertView

class SurveyViewController: UIViewController {
    
    @IBOutlet weak var firstnameTextfield: UITextField!
    @IBOutlet weak var lastnameTextfield: UITextField!
    @IBOutlet weak var fitnessLevel: UISegmentedControl!
    @IBOutlet weak var workoutFreq: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submit(_ sender: UIButton) {
        guard let firstname = firstnameTextfield.text else {
            let alert = SCLAlertView()
            alert.showError("Incomplete", subTitle: "Please enter your first name.")
            return
        }
        guard let lastname = lastnameTextfield.text else {
            let alert = SCLAlertView()
            alert.showError("Incomplete", subTitle: "Please enter your last name.")
            return
        }
        
        let fitnessLevel = self.fitnessLevel.selectedSegmentIndex
        let workoutFreq = self.workoutFreq.selectedSegmentIndex
        
        if fitnessLevel == UISegmentedControlNoSegment || workoutFreq == UISegmentedControlNoSegment{
            let alert = SCLAlertView()
            alert.showError("Incomplete", subTitle: "Please enter both a fitness level and a workout frequency.")
            return
        }
        
        if firstname == "" || lastname == ""{
            let alert = SCLAlertView()
            alert.showError("Incomplete", subTitle: "Please enter both a first and last name.")
            return
        }
        
        let response = User.SurveyResponse()
        response.intensity = User.SurveyResponse.Intensity(rawValue: fitnessLevel)!
        response.frequency = User.SurveyResponse.Frequency(rawValue: workoutFreq)!
        
        if let user = User.current() {
            user.finishSignUp(survey: response, firstName: firstname, lastName: lastname, block: { (error) in
                if error != nil{
                    let alert = SCLAlertView()
                    alert.showError("Encountered an Error.", subTitle: "")
                    
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }else{
            let alert = SCLAlertView()
            alert.showError("User missing.", subTitle: "")
        }
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
