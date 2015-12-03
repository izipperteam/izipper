//
//  SecondViewController.swift
//  izipper
//
//  Created by Frank on 10/29/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import UIKit

//MARK: implement timeAndLocationDataSource protocol
protocol timeAndLocationDataSource: class {
    func transmitTimeAndLocation(sender: SetupViewController) -> [(String, String)]?
}




//MARK: implement HistoryTableViewController
class HistoryTableViewController: UITableViewController {
    
    var timeAndLocation: timeAndLocationDataSource?
    var data:[(String, String)]? {
        get{
            guard let dataSource = self.timeAndLocation as? [(String, String)] else {
                return nil
            }
            return dataSource
        }
        
    }
    
    
    
    override func viewDidLoad() {
        
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sequence = self.data {
            return sequence.count
        }
        return 1
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! HistoryTableViewCell
        if let firstSet = self.data?.dropFirst().first! {
            cell.timeAndLocationLabel.text = "time: \(firstSet.0), location:\(firstSet.1)"
        }
        return cell
    }
}