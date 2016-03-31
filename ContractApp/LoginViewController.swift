//
//  ViewController.swift
//  LoginAnimation
//
//  Created by Allen on 16/1/18.
//  Copyright © 2016年 Allen. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: BaseUIViewController {
    

    @IBOutlet weak var uesernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    let loginService = LoginService()
    let loginUserStore = LoginUserStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //uesernameTextField.layer.cornerRadius = 5
        //passwordTextField.layer.cornerRadius = 5
        //loginButton.layer.cornerRadius = 5
        
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func loginButtonDidTouch(sender: UIButton) {
        

        let userName = (uesernameTextField.text)!
        let password = (passwordTextField.text)!
        
        if userName.isEmpty || password.isEmpty {
            displayMessage("用户名和密码不能为空")
            return
        }

        loadingOverlay.showOverlay(self.view)
        loginService.login(userName, password: password) { response in
            
            dispatch_async(dispatch_get_main_queue()) {
                self.loadingOverlay.hideOverlayView()
                if response.status == 0 {
                    if response.isSuccess {
                        //删除之前登录的数据
                        self.loginUserStore.removeLoginUser()
                        
                        //存储登录的信息
                        let context = self.loginUserStore.coreDataStack.mainQueueContext
                        var user: LoginUser!
                        context.performBlockAndWait() {
                            user = NSEntityDescription.insertNewObjectForEntityForName("LoginUser", inManagedObjectContext: context) as! LoginUser
                            user.userName = userName
                            user.department = response.department
                            user.name = response.name
                        }
                        
                        do {
                            try self.loginUserStore.coreDataStack.saveChanges()
                        }
                        catch let error {
                            print("Core Data save failed: \(error)")
                        }
                        
                        
                        self.performSegueWithIdentifier("loginSuccessSegue", sender: self)
                    } else {
                        self.displayMessage(response.errMessage!)
                    }
                } else {
                    self.displayMessage(response.errorMessage!)
                }
            }
            
        }
        
        
    }
    
   
}

