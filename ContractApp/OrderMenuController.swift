//
//  OrderMenuController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class OrderMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var items = ["合同基本信息", "收购合同信息", "出运信息", "出厂付款信息", "收汇信息"]
    
    var order: Order!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderMenuCell")
        cell?.textLabel?.text = items[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            self.performSegueWithIdentifier("basicInfoSegue", sender: order)
        }
        
        if indexPath.row == 1 {
            self.performSegueWithIdentifier("shougouSegue", sender: order)
        }
    }


}
