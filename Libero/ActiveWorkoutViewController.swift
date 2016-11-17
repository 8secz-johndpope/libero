//
//  ActiveWorkoutViewController.swift
//  Libero
//
//  Created by John Kotz on 11/2/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import UIKit

class ActiveWorkoutViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var beginButton: UIButton!
    
    var workout: Workout!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = L.grey
        
        timeLabel.text = "00:00:00"
        distanceLabel.text = "0.0"
        
        if workout.isActive {
            self.updateLabels()
            workout.startTimer { (_) in
                self.updateLabels()
            }
            beginButton.setTitle("End", for: .normal)
        }
    }
    
    func cancel() {
        self.beginButton.setTitle("Begin", for: .normal)
        workout.endWorkout()
        workout.stopLocationTracking()
        
        workout.stopTimer()
        
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func beginPressed(_ sender: UIButton) {
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ActiveWorkoutViewController.cancel))
        if !workout.isActive {
            sender.setTitle("End", for: .normal)
            workout.startWorkout()
            workout.startLocationTracking()
            
            workout.startTimer { (_) in
                self.updateLabels()
            }
        }else{
            sender.setTitle("Begin", for: .normal)
            workout.endWorkout()
            workout.stopLocationTracking()
            
            workout.stopTimer()
        }
    }
    
    func updateLabels() {
        let duration = workout.getDuration()
//        let distance = (workout.data as! Workout.Subdata.Distance).distance
        
        if duration.hours <= 0 {
            timeLabel.text = duration.milisecondsStringValue()
        }else{
            timeLabel.text = duration.secondsStringValue()
        }
        
        if let distance = (workout.data as? Workout.Subdata.Distance)?.distance {
            self.distanceLabel.text = String(format: "%.1f", distance.miles)
        }
    }
}

extension TimeInterval {
    var hours: Int {
        return Int(self) / 3600
    }
    
    func milisecondsStringValue() -> String {
        let interval = Int(self)
        let ms = Int(self * 100) % 100
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d:%02d", minutes, seconds, ms)
    }
    
    func secondsStringValue() -> String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
