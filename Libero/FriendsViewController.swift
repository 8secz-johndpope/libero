//
//  FriendsViewController.swift
//  Libero
//
//  Created by Nitasha Kochar on 10/30/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class FriendsViewController: UIViewController,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Results"
        let attrs = [NSFontAttributeName: UIFont(name: "Avenir", size: 23)!]
        return NSAttributedString(string: str, attributes: attrs)
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataSetSource = self
        emptyDataSetDelegate = self
        tableFooterView = UIView()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
