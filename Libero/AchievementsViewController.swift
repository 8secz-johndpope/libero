//
//  AchievementsViewController.swift
//  Libero
//
//  Created by John Kotz on 11/13/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import UIKit

class AchievementsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var achievements: [(acheivement: Achievement, completed: Bool)] = []
    
    override func viewDidLoad() {
        
        L.setUpNavBar(navBar: (self.navigationController?.navigationBar)!)
        view.backgroundColor = L.grey
        
        let test1 = (acheivement: Achievement(name: "10 miles run", type: .first), completed: true)
        let test2 = (acheivement: Achievement(name: "25 miles run", type: .second), completed: true)
        let test3 = (acheivement: Achievement(name: "50 miles run", type: .third), completed: false)
        let test4 = (acheivement: Achievement(name: "100 miles run", type: .fourth), completed: false)
        
        let test1A = (acheivement: Achievement(name: "20 miles bike", type: .first), completed: true)
        let test2A = (acheivement: Achievement(name: "100 miles bike", type: .second), completed: false)
        let test3A = (acheivement: Achievement(name: "250 miles bike", type: .third), completed: false)
        let test4A = (acheivement: Achievement(name: "500 miles bike", type: .fourth), completed: false)
        
        let test1B = (acheivement: Achievement(name: "5 miles swam", type: .first), completed: false)
        let test2B = (acheivement: Achievement(name: "10 miles swam", type: .second), completed: false)
        let test3B = (acheivement: Achievement(name: "20 miles swam", type: .third), completed: false)
        let test4B = (acheivement: Achievement(name: "30 miles swam", type: .fourth), completed: false)
        
        let test1C = (acheivement: Achievement(name: "10 miles walk", type: .first), completed: true)
        let test2C = (acheivement: Achievement(name: "25 miles walk", type: .second), completed: true)
        let test3C = (acheivement: Achievement(name: "50 miles walk", type: .third), completed: true)
        let test4C = (acheivement: Achievement(name: "100 miles walk", type: .fourth), completed: false)
        
        achievements = [test1, test2, test3, test4, test1A, test2A, test3A, test4A, test1B, test2B, test3B, test4B, test1C, test2C, test3C, test4C]
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "acheivementCell", for: indexPath) as! AchievementCollectionCell
        
        let achievement = self.achievements[indexPath.row].acheivement
        
        cell.type = achievement.type
        cell.descriptionText = achievement.name
        cell.enabled = self.achievements[indexPath.row].completed
        
        return cell
    }
}

class AchievementCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    private var privateType: Achievement.TypeEnum?
    var type: Achievement.TypeEnum {
        set {
            privateType = newValue
            updateImage()
        }
        get {
            return privateType ?? .unknown
        }
    }
    
    var descriptionText: String? {
        set {
           descriptionLabel.text = newValue?.uppercased()
        }
        get {
            return descriptionLabel.text
        }
    }
    
    var enabled: Bool {
        set {
            if newValue {
                self.imageView.layer.opacity = 1.0
                self.descriptionLabel.textColor = UIColor.white
            }else{
                self.imageView.layer.opacity = 0.4
                self.descriptionLabel.textColor = UIColor.gray
            }
        }
        get {
            return true
        }
    }
    
    private func updateImage() {
        if let type = privateType {
            switch type {
            case .first:
                imageView.image = #imageLiteral(resourceName: "medal-1")
                break
                
            case .second:
                imageView.image = #imageLiteral(resourceName: "medal-2")
                break
                
            case .third:
                imageView.image = #imageLiteral(resourceName: "medal-3")
                break
                
            case .fourth:
                imageView.image = #imageLiteral(resourceName: "medal-4")
                break
            
            case .unknown:
                imageView.image = #imageLiteral(resourceName: "unknownAchievement")
            }
        }else{
            imageView.image = #imageLiteral(resourceName: "medal-1")
        }
    }
}
