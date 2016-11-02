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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let firstNameTextFieldRow = TextFieldRowFormer<FormTextFieldCell>()
            .configure { row in
                row.rowHeight = 44
                row.placeholder = "First Name"
            }.onSelected { row in
                // Do Something
                
        }
        
        let lastNameTextFieldRow = TextFieldRowFormer<FormTextFieldCell>()
            .configure { row in
                row.rowHeight = 44
                row.placeholder = "Last Name"
            }.onSelected { row in
                row.cell.textField.becomeFirstResponder()
                
        }
        
        let activityLevels = ["Beginner", "Intermediate", "Advanced", "Enthusiast"]
        
        let activityLevelPicker = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            $0.titleLabel.text = "Activity Level"
            }.configure { row in
                row.pickerItems = (0...3).map {
                    InlinePickerItem(title: activityLevels[$0], value: Int($0))
                }
            }.onValueChanged { item in
                // Do Something
        }
        
        let workoutFrequency = ["<1 per week", "1 per week", "2-3 per week", "4+ per week"]
        
        let workoutFreqPicker = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            $0.titleLabel.text = "Workout Frequency"
            }.configure { row in
                row.pickerItems = (0...3).map {
                    InlinePickerItem(title: workoutFrequency[$0], value: Int($0))
                }
            }.onValueChanged { item in
                // Do Something
        }

        let section1 = SectionFormer(rowFormer: firstNameTextFieldRow)
        former.append(sectionFormer: section1)
        let section2 = SectionFormer(rowFormer: lastNameTextFieldRow)
        former.append(sectionFormer: section2)
        let section3 = SectionFormer(rowFormer: activityLevelPicker)
        former.append(sectionFormer: section3)
        let section4 = SectionFormer(rowFormer: workoutFreqPicker)
        former.append(sectionFormer: section4)

        // Create Headers and Footers
        
        // Create Headers and Footers
        
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 44
            }
        }
        



        // Do any additional setup after loading the view.
    }


}

