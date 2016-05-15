//
//  LaunchViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/14.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class LaunchViewController: BaseUIViewController {
    
    var serviceLocatorStore = ServiceLocatorStore()
    var loginUserStore = LoginUserStore()
    var locatorService = LocatorService()
    
    override func viewDidAppear(animated: Bool) {
        /*
        if checkIsOutDate() {
            displayMessage("版本已过期")
            return
        }*/
        
        //检查一下是否已经登录，如果登录，则直接进入后面的页面
        if self.loginUserStore.GetLoginUser() != nil {
            print("found login user")
            self.performSegueWithIdentifier("hasLoginSegue", sender: self)
        } else {
            print("no login user")
            self.performSegueWithIdentifier("notLoginSegue", sender: self)
        }
        
        /*
        locatorService.getServiceLocator() { resp -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if resp.status != 0 {
                    self.displayMessage("获取ServiceLocator失败")
                    return
                }
                
                let oldServiceLocator = self.serviceLocatorStore.GetServiceLocator()
                if oldServiceLocator == nil {
                    
                    let saveResult = self.serviceLocatorStore.saveServiceLocator(resp.result!)
                    if !saveResult {
                        self.displayMessage("保存ServiceLocator失败")
                    }
                } else {
                    //检查ServiceLocator是否发生更新，如果更新过，应该让登录失效
                    if oldServiceLocator?.http != resp.result?.http ||
                       oldServiceLocator?.serverName != resp.result?.serverName ||
                        oldServiceLocator?.port != resp.result?.port {
                        self.loginUserStore.removeLoginUser()
                    }
                    
                    oldServiceLocator?.http = resp.result?.http
                    oldServiceLocator?.serverName = resp.result?.serverName
                    oldServiceLocator?.port = resp.result?.port
                    let saveResult = self.serviceLocatorStore.UpdateServiceLocator()
                    if !saveResult {
                        self.displayMessage("更新ServiceLocator失败")
                    }
                    
                }
                
                //检查一下是否已经登录，如果登录，则直接进入后面的页面
                if self.loginUserStore.GetLoginUser() != nil {
                    print("found login user")
                    self.performSegueWithIdentifier("hasLoginSegue", sender: self)
                } else {
                    print("no login user")
                    self.performSegueWithIdentifier("notLoginSegue", sender: self)
                }
            }
            
        }*/
        
    }
    
    private func checkIsOutDate() -> Bool {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let currentDateTime = NSDate()
        if formatter.stringFromDate(currentDateTime) >= "2016-05-30" {
            return true
        }
        return false
        
    }
    
}
