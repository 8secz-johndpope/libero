//
//  Leaderboard2ViewController.swift
//  Libero
//
//  Created by ArminM on 11/16/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit

class Leaderboard2ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activitySelect: UISegmentedControl!
    
    let labels = ["RUN", "BIKE", "SWIM", "CIRCUIT"]
    
    @IBAction func activityChanged(_ sender: Any) {
        activityLabel.text = labels[activitySelect.selectedSegmentIndex]
        backgroundImage.image = UIImage(named: "workout_\(activitySelect.selectedSegmentIndex + 1)")
    }
    
    
    let locations = ["Washington DC", "Seattle, WA", "Boston, MA", "Dallas, TX"]
    
    let names = ["Benjamin M.", "Ken M.", "Kellyanne K.", "Donald T."]
    
    let challenges = ["85", "73", "45"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        activitySelect.tintColor = UIColor.white
        
        activityLabel.textColor = UIColor.white

        backgroundImage.image = UIImage(named: "workout_1")
        L.setUpNavBar(navBar: (self.navigationController?.navigationBar)!)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell") as! LeaderboardCell
        
        cell.location.text = locations[indexPath.row]
        cell.name.text = names[indexPath.row]
        cell.challenges.text = challenges[indexPath.row] + " Challenges Completed"
        cell.rank.text = String(indexPath.row + 1)
        
        // your cell coding
        return cell
        
        
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
