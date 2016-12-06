//
//  MyActivityCell.swift
//  Libero
//
//  Created by Nitasha Kochar on 11/6/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit

class MyActivityCell: UITableViewCell {

    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    
    
    var title: String {
        set {
           activityTitle.text = newValue
        }
        get {
            return activityTitle.text ?? ""
        }
    }
    
    private var privateDate: Date?
    var date: Date? {
        set {
            privateDate = newValue
            
            if let newValue = newValue {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .none
            
                dateLabel.text = dateFormatter.string(from: newValue)
            }else{
                dateLabel.text = ""
            }
        }
        get {
            return privateDate
        }
    }
    
    var descriptionString: String {
        get {
            return descriptionLabel.text ?? ""
        }
        set {
            descriptionLabel.text = newValue
        }
    }
    
    private var privateType: Workout.Name?
    var type: Workout.Name? {
        get {
            return self.privateType
        }
        
        set {
            privateType = newValue
            
            if let newValue = newValue {
                switch newValue {
                case .bike:
                    myImageView.image = #imageLiteral(resourceName: "BIKE")
                    self.title = "Bike"
                    
                case .run:
                    myImageView.image = #imageLiteral(resourceName: "RUN")
                    self.title = "Run"
                    
                case .swim:
                    myImageView.image = #imageLiteral(resourceName: "SWIM")
                    self.title = "Swim"
                    
                case .walk:
                    myImageView.image = #imageLiteral(resourceName: "user")
                    self.title = "Walk"
                    
                default:
                    myImageView.image = #imageLiteral(resourceName: "user")
                    self.title = "Workout"
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
