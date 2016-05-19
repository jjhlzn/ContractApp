//
//  MyInfoViewController2.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/27.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class MyInfoViewController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate{
    
    var loginUser: LoginUser!
    var loginUserStore = LoginUserStore()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loginUser = loginUserStore.GetLoginUser()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            return 153
        case 1:
            return 44
        case 2:
            return 71
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("myInfoMainCell") as! MyInfoMainCell
            cell.userNameLabel.text = loginUser.name
            return cell
        } else if section == 1 {
            if row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("myInfoOtherCell") as! MyInfoCell
                cell.nameLabel.text = "帐号"
                cell.valueLabel.text = loginUser.userName
                return cell
            } else if row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("myInfoOtherCell") as! MyInfoCell
                cell.nameLabel.text = "部门"
                cell.valueLabel.text = loginUser.department
                return cell
            } else  {
                let cell = tableView.dequeueReusableCellWithIdentifier("myInfoOtherCell") as! MyInfoCell
                cell.nameLabel.text = "版本号"
                let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
                let appBundle = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String

                cell.valueLabel.text = "\(version) (\(appBundle))"
                return cell

            }
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("logoutCell")!
            //cell.backgroundColor = tableView.backgroundColor
            return cell
        }
    }

    @IBAction func logoutPressed(sender: AnyObject) {
        displayConfirmMessage("确认退出登录吗？", delegate: self)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).unregisterDeviceTokenFromServer()  {
                response -> Void in
                self.loginUserStore.removeLoginUser()
                self.performSegueWithIdentifier("logoutSegue", sender: nil)
            }
            
            break;
        case 1:
            break;
        default:
            break;
        }
    }
}
