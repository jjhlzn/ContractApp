//
//  MyInfoViewController2.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/27.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class MyInfoViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var loginUser: LoginUser!
    var loginUserStore = LoginUserStore()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loginUser = loginUserStore.GetLoginUser()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        
        if row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("myInfoCell") as! MyInfoCell
            cell.nameLabel.text = "用户名"
            cell.valueLabel.text = loginUser.userName
            return cell
        } else if row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("myInfoCell") as! MyInfoCell
            cell.nameLabel.text = "姓名"
            cell.valueLabel.text = loginUser.name
            return cell
        } else if row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("myInfoCell") as! MyInfoCell
            cell.nameLabel.text = "部门"
            cell.valueLabel.text = loginUser.department
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("logoutCell")!
            return cell
        }
    
    }

    @IBAction func logoutPressed(sender: AnyObject) {
        loginUserStore.removeLoginUser()
        performSegueWithIdentifier("logoutSegue", sender: nil)
    }
   }
