//
//  LoginViewController.swift
//  OnlineClass
//
//  Created by 刘兆娜 on 16/4/23.
//  Copyright © 2016年 tbaranes. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class LoginViewController: BaseUIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logImage: UIImageView!
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    var loginService = LoginService()
    var loginUserStore = LoginUserStore()
    var isKeyboardShow = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        super.hideKeyboardWhenTappedAround()
        
        setTextFieldHeight(userNameField, height: 45)
        setTextFieldHeight(passwordField, height: 45)
        
        
        becomeLineBorder(userNameField)
        becomeLineBorder(passwordField)
        
        addIconToField(userNameField, imageName: "userIcon")
        addIconToField(passwordField, imageName: "password")
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        print("width = \(screenWidth), height = \(screenHeight)")
        if screenHeight < 667 {
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        }
        
        
    }
    
    
    
    func addIconToField(field: UITextField, imageName: String) {
        let imageView = UIImageView();
        let image = UIImage(named: imageName);
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        view.addSubview(imageView)
        imageView.image = image;
        //field.leftView = imageView
        
        //field.leftViewMode = UITextFieldViewMode.Always
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 40, 25))
        paddingView.addSubview(imageView)
        field.leftView = paddingView;
        field.leftViewMode = UITextFieldViewMode.Always
    }
    
    
    var originFrame: CGRect?
    var originCenter: CGPoint?
    func keyboardWillShow(notification: NSNotification) {
        
        if !isKeyboardShow {
            view.frame.origin.y -= 65
            
            var frame = logImage.frame
            originFrame = logImage.frame
            frame.size.width = 70
            frame.size.height = 70
            originCenter = logImage.center
            logImage.frame = frame
            logImage.center.x = originCenter!.x
            logImage.center.y = originCenter!.y + 10
        }
        isKeyboardShow = true
        
    }
    
    
    
    func keyboardWillHide(notification: NSNotification) {
        isKeyboardShow = false
        
        view.frame.origin.y += 65
        logImage.frame = originFrame!
        logImage.center = originCenter!
    }
    
    
    @IBAction func loginButtonDidTouch(sender: UIButton) {
        
        
        let userName = (userNameField.text)!
        let password = (passwordField.text)!
        
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
                        if response.errMessage != nil {
                            self.displayMessage(response.errMessage!)
                        } else {
                            self.displayMessage("登录失败")
                        }
                    }
                } else {
                    self.displayMessage(response.errorMessage!)
                }
            }
            
        }
        
        
    }

    
}
