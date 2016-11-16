//
//  WorkoutSelectCell.swift
//  Libero
//
//  Created by Jane Lee on 11/1/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit

class WorkoutSelectCell: UITableViewCell {
    
    @IBOutlet weak var workoutTitle: UILabel!
    @IBOutlet weak var workoutSubtitle: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        workoutTitle.textColor = L.yellow
        workoutSubtitle.textColor = L.yellow
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
