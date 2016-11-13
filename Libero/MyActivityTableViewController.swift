//
//  MyActivityTableViewController.swift
//  Libero
//
//  Created by Nitasha Kochar on 11/13/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import SCLAlertView

class MyActivityTableViewController: UITableViewController {
    
    let activityList = ["Monday Morning Bike", "Tuesday Evening Jog", "Wednesday Evening Walk"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        L.setUpNavBar(navBar: navigationController!.navigationBar)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(MyActivityTableViewController.logout))
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
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myHeaderCell") as! MyActivityHeaderCell
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myActivityCell", for: indexPath) as! MyActivityCell
            
            cell.activityTitle.text = activityList[indexPath.row-1].uppercased()
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
    
    
    
    
}
