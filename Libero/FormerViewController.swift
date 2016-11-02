//
//  FormerViewController.swift
//  Libero
//
//  Created by Nitasha Kochar on 10/31/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import Former

class FormerViewController: FormViewController {

    
    @IBAction func submitPressed(_ sender: Any) {
        
        print(firstName)
        print(lastName)
        print(workoutFrequency)
        print(intensity)

        
        let response = User.SurveyResponse(firstName: firstName, lastName: lastName, frequency: User.SurveyResponse.Frequency(rawValue: workoutFrequency)!, intensity: User.SurveyResponse.Intensity(rawValue: intensity)!)
        
        // When you are done:
        guard let user = User.current() else {
            return
        }
        user.finishSignUp(survey: response) { (error) in
            if error != nil {
                print("boo")
                // Something went wrong!
            }else{
                print("yay")
                // All's fine!
                
                //do segue, allow them to enter app
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let tabVC = mainStoryboard.instantiateViewController(withIdentifier: "tabController")
                self.present(tabVC, animated: true, completion: nil)
            }
        }
        
    }
    
    var firstName = ""
    var lastName = ""
    var workoutFrequency = 0
    var intensity = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 44
            }
        }
        
        
        let firstNameTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
                $0.titleLabel.text = "First Name"
            }
            .configure { row in
                row.rowHeight = 44
                row.placeholder = "Enter your first name"
            }.onSelected { row in
                
        }.onTextChanged { (nameText) in
            self.firstName = nameText
        }
        
        let lastNameTextFieldRow = TextFieldRowFormer<FormTextFieldCell>() {
                $0.titleLabel.text = "Last Initial"
            }
            .configure { row in
                row.rowHeight = 44
                row.placeholder = "Enter your last initial"
            }.onSelected { row in
                row.cell.textField.becomeFirstResponder()
                
        }.onTextChanged { (lastText) in
            self.lastName = lastText
        }
        
        let activityLevels = ["Beginner", "Intermediate", "Advanced", "Enthusiast"]
        
        let activityLevelPicker = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            $0.titleLabel.text = "Activity Level"
            }.configure { row in
                row.pickerItems = (0...3).map {
                    InlinePickerItem(title: activityLevels[$0], value: Int($0))
                }
            }.onValueChanged { item in
                self.intensity = item.value!
        }
        
        let workoutFrequency = ["Less than 1 per week", "1 per week", "2-3 per week", "4+ per week"]
        
        let workoutFreqPicker = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            $0.titleLabel.text = "Workout Frequency"
            }.configure { row in
                row.pickerItems = (0...3).map {
                    InlinePickerItem(title: workoutFrequency[$0], value: Int($0))
                }
            }.onValueChanged { item in
                self.workoutFrequency = item.value!
                // Do Something
        }

        let nameSection = SectionFormer(rowFormers: [firstNameTextFieldRow, lastNameTextFieldRow]).set(headerViewFormer: createHeader("Tell us a bit about yourself"))
        
//        let section1 = SectionFormer(rowFormers: firstNameTextFieldRow)
        former.append(sectionFormer: nameSection)
//        let section2 = SectionFormer(rowFormer: lastNameTextFieldRow)
//        former.append(sectionFormer: section2)
        let section3 = SectionFormer(rowFormer: activityLevelPicker)
        former.append(sectionFormer: section3)
        let section4 = SectionFormer(rowFormer: workoutFreqPicker)
        former.append(sectionFormer: section4)

        // Create Headers and Footers
        
        // Create Headers and Footers
        
        



        // Do any additional setup after loading the view.
    }


}

