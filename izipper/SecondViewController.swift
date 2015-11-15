//
//  SecondViewController.swift
//  izipper
//
//  Created by Frank on 10/29/15.
//  Copyright © 2015 izipperteam. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    struct FeatureItem {
        var title: String
        var enabled: Bool
        
        init(title: String, enabled: Bool) {
            self.title = title
            self.enabled = enabled
        }
    }
    
    var features = [FeatureItem]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        features.append(FeatureItem(title: "BLE connection", enabled: false))
        features.append(FeatureItem(title: "Light", enabled: false))
        features.append(FeatureItem(title: "Buzzer", enabled: false))
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        cell.Item.text = self.features[indexPath.row].title
        cell.Switch.enabled = self.features[indexPath.row].enabled
        
        return cell
    }
    
    


}

