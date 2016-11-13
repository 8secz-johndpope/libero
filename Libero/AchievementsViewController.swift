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
    
    var achievements: [Achievement] = []
    
    override func viewDidLoad() {
        var test1 = Achievement(name: "100 miles run", type: .first)
        var test2 = Achievement(name: "20 miles swim", type: .second)
        var test3 = Achievement(name: "20 miles swim", type: .second)
        var test4 = Achievement(name: "20 miles swim", type: .second)
        var test5 = Achievement(name: "20 miles swim", type: .second)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "acheivementCell", for: indexPath) as! AchievementCollectionCell
        
        cell.type = .first
        
        return UICollectionViewCell()
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
