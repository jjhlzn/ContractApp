//
//  AppDelegate.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/1/5.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let color = UIColor(red: 5/255.0, green: 96/255.0, blue: 157/255.0, alpha: 1.0)

        UITabBar.appearance().tintColor = color
        UINavigationBar.appearance().tintColor = color
        
        
        let serviceLocatorStore = ServiceLocatorStore()
        if serviceLocatorStore.GetServiceLocator() == nil {
            let serviceLocator = ServiceLocator()
            serviceLocator.http = "http"
            serviceLocator.serverName = "jjhtest.hengdianworld.com"
            serviceLocator.port = 80
            serviceLocatorStore.saveServiceLocator(serviceLocator)
        }
        
        registerForPushNotifications(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func registerForPushNotifications(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) {
        XGPush.startApp(2200199196, appKey:"IW7L767TA5BH");
        
        XGPush.initForReregister { () -> Void in
            
            if(!XGPush.isUnRegisterStatus()){
                
                print("注册通知");
                
                if (UIApplication.instancesRespondToSelector(Selector( "registerUserNotificationSettings:" ))){
                    
                    let notificationSettings = UIUserNotificationSettings(
                        forTypes: [.Badge, .Sound, .Alert], categories: nil)
                    application.registerUserNotificationSettings(notificationSettings)
                    
                    application.registerForRemoteNotifications();
                    
                    
                    
                } else {
                    
                   // application.registerForRemoteNotificationTypes(.Alert | .Sound | .Badge);
                    let notificationSettings = UIUserNotificationSettings(
                        forTypes: [.Badge, .Sound, .Alert], categories: nil)
                    application.registerUserNotificationSettings(notificationSettings)
                    
                    application.registerForRemoteNotifications();
                }
                
            }
            
        }
        
        //推送反馈(app不在前台运行时，点击推送激活时)
        XGPush.handleLaunching(launchOptions)
    }
    
    
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    //应用在进入前台时会执行的代码
    func applicationWillEnterForeground(application: UIApplication) {
        print("applicationWillEnterForeground")
        
        
        let currentViewController = getVisibleViewController(nil)
        
        if currentViewController != nil {
            let tabBarController = currentViewController?.parentViewController as? UITabBarController
            if tabBarController != nil {
                let tabArray = tabBarController!.tabBar.items as NSArray!
                let tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
                if application.applicationIconBadgeNumber > 0 {
                    tabItem.badgeValue = "\(application.applicationIconBadgeNumber)"
                }
            }
            
            if let navController = currentViewController as? UINavigationController {
                if let topController = navController.topViewController as? ApprovalListViewController {
                    topController.refresh(application)
                    topController.tableView.reloadData()
                }
            }
        }

    }
    
    var deviceToken = ""
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let  deviceTokenStr : String = XGPush.registerDevice(deviceToken);
        print("Device Token:", deviceTokenStr)
        self.deviceToken = deviceTokenStr
        registerDeviceTokenToServer() { response -> Void in
            
        }
    }
    
    func registerDeviceTokenToServer(completion: ((response: RegisterDeviceResponse) -> Void)) {
        let loginUser = LoginUserStore().GetLoginUser()
        if loginUser != nil {
            LoginService().registerDevice((loginUser?.userName)!, deviceToken: deviceToken, completion: completion)
            print("register \(deviceToken) to \((loginUser?.userName)!)")
        }
    }
    
    func unregisterDeviceTokenFromServer(completion: ((response: RegisterDeviceResponse) -> Void)) {
        let loginUser = LoginUserStore().GetLoginUser()
        if loginUser != nil {
            LoginService().registerDevice((loginUser?.userName)!, deviceToken: "", completion: completion)
            print("unregister \(deviceToken) to \((loginUser?.userName)!)")
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            
            print ( "Push notifications are not supported in the iOS Simulator." )
            
        } else {
            
            print ( "application:didFailToRegisterForRemoteNotificationsWithError: \(error) " )
            
        }
    }

    
    //app在前台运行时收到远程通知
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("userInfo: ")
        print(userInfo);
        print("---------")
        XGPush.handleReceiveNotification(userInfo);
        //badgeCount = badgeCount + 1
        
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let badge = aps["badge"] as? Int {
                application.applicationIconBadgeNumber = badge
            }
        }
        
        if (application.applicationState == .Active ) {

            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            let currentViewController = getVisibleViewController(nil)
            
            if currentViewController != nil {
                let tabBarController = currentViewController?.parentViewController as? UITabBarController
                if tabBarController != nil {
                    let tabArray = tabBarController!.tabBar.items as NSArray!
                    let tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
                    tabItem.badgeValue = "\(application.applicationIconBadgeNumber)"
                }
                
                if let navController = currentViewController as? UINavigationController {
                    if let topController = navController.topViewController as? ApprovalListViewController {
                        let approval = createApprovalFromNotificaiton(userInfo)
                        topController.approvals.insert(approval, atIndex: 0)
                        topController.tableView.reloadData()
                        topController.setFootText()
                    }
                }
            }
            
        }
    }
    
    private func createApprovalFromNotificaiton(userInfo: [NSObject : AnyObject]) -> Approval {
        let approval = Approval()
        if let aps = userInfo["aps"] as? NSDictionary {
            if let json = aps["approval"] as? NSDictionary {
                approval.id = json["id"] as? String
                approval.amount = json["amount"] as! NSNumber
                approval.approvalObject = json["approvalObject"] as? String
                approval.approvalResult = json["approvalResult"] as? String
                approval.keyword = json["keyword"] as? String
                approval.reportDate = json["reportDate"] as? String
                approval.reporter = json["reporter"] as? String
                approval.status = json["status"] as? String
                approval.type = json["type"] as? String
            }
        }
        return approval
    }
    
    func getVisibleViewController(var rootViewController: UIViewController?) -> UIViewController? {
        
        if rootViewController == nil {
            rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        }
        
        if rootViewController?.presentedViewController == nil {
            return rootViewController
        }
        
        if let presented = rootViewController?.presentedViewController {
            if presented.isKindOfClass(UINavigationController) {
                let navigationController = presented as! UINavigationController
                print(navigationController.viewControllers.last!)
                return navigationController.viewControllers.last!
            }
            
            if presented.isKindOfClass(UITabBarController) {
                let tabBarController = presented as! UITabBarController
                print(tabBarController.selectedViewController!)
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }


}

