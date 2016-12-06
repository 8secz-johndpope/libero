//
//  MyActivityTableViewController.swift
//  Libero
//
//  Created by Nitasha Kochar on 11/13/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import SCLAlertView
import DZNEmptyDataSet

class MyActivityTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var activityList: [Workout] = []
    
    
    
    
    /** Start Empty Data Protocol */
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Results"
        let attrs = [NSFontAttributeName: UIFont(name: "Avenir", size: 23)!]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        L.setUpNavBar(navBar: (self.navigationController?.navigationBar)!)
        
        let workout1 = Workout(type: .distance, activity: .run)
        let workout2 = Workout(type: .distance, activity: .bike)
        let workout3 = Workout(type: .distance, activity: .swim)
        
        activityList = [workout1, workout2, workout3]
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(MyActivityTableViewController.logout))
        
//        if let user = User.current(), let workouts = user.pastWorkouts {
//            self.activityList = workouts
//        }else if let user = User.current() {
//            user.initialize({ (user) in
//                if let workouts = user.pastWorkouts {
//                    self.activityList = workouts
//                    self.tableView.reloadData()
//                }
//            })
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if let user = User.current(), let workouts = user.pastWorkouts {
//            self.activityList = workouts
//            self.tableView.reloadData()
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logout() {
        User.logout { (error) in
            if let _ = error {
                let alert = SCLAlertView()
                alert.showError("Failed to Logout!", subTitle: "")
            }else{
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "login")
                
                self.present(loginViewController, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activityList.count+1
        //        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myHeaderCell") as! MyActivityHeaderCell
            
            
            for label in cell.labels {
                label.textColor = L.grey
                
            }
            
            cell.numOfWorkouts.text = "\(activityList.count)"
            if activityList.count == 1 {
                cell.workoutLabel.text = "WORKOUT"
            }else{
                cell.workoutLabel.text = "WORKOUTS"
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myActivityCell", for: indexPath) as! MyActivityCell
            
            let workout = activityList[indexPath.row - 1]
            
            cell.type = workout.typeInfo.name
            cell.date = workout.createdAt
            cell.descriptionString = String(format: "%.2f miles", (workout.data as! Workout.Subdata.Distance).distance.miles)
            
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 217
            
        default:
            return 84
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


class MyActivityHeaderCell: UITableViewCell {
    
    @IBOutlet weak var numOfWorkouts: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    
    @IBOutlet weak var numOfWins: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    
    @IBOutlet weak var numOfMedals: UILabel!
    @IBOutlet weak var medalsLabel: UILabel!
    
    @IBOutlet var labels: [UILabel]!
    
    
}
