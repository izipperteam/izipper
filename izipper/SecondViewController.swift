//
//  SecondViewController.swift
//  izipper
//
//  Created by Frank on 10/29/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let object: NSMutableArray! = NSMutableArray()
    let status: NSMutableArray! = NSMutableArray()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.object.addObject("BLE connection")
        self.object.addObject("Light")
        self.object.addObject("Buzzer")
        self.status.addObject("On")
        self.status.addObject("Off")
        self.tableView.reloadData()
        
        //MARK: BLE setup
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return object.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        cell.Status.text = self.status.objectAtIndex(0) as! String
        cell.Item.text = self.object.objectAtIndex(indexPath.row) as! String
        
        return cell
    }
    
    


}

