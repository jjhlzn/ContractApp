//
//  LaunchViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/14.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    var loginUserStore = LoginUserStore()
    
    override func viewDidAppear(animated: Bool) {

        //检查一下是否已经登录，如果登录，则直接进入后面的页面
        if loginUserStore.GetLoginUser() != nil {
            print("found login user")
            self.performSegueWithIdentifier("hasLoginSegue", sender: self)
        } else {
            print("no login user")
            self.performSegueWithIdentifier("notLoginSegue", sender: self)
        }
    }
    
}
