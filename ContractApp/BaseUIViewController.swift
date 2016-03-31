//
//  BaseUIViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/11.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {
    var loadingOverlay = LoadingOverlay()
    
    
    func displayMessage(message : String) {
        
        let alertView = UIAlertView()
        //alertView.title = "系统提示"
        alertView.message = message
        alertView.addButtonWithTitle("好的")
        alertView.cancelButtonIndex=0
        alertView.delegate=self
        alertView.show()
        
    }
    
    func displayConfirmMessage(message : String, delegate: UIAlertViewDelegate) {
        let alertView = UIAlertView()
        //alertView.title = "系统提示"
        alertView.message = message
        alertView.addButtonWithTitle("确认")
        alertView.addButtonWithTitle("取消")
        alertView.delegate=delegate
        alertView.show()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       // self.hideKeyboardWhenTappedAround()
    }
    
    func checkDate(date: String) -> Bool {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.dateFromString(date) != nil 
    }
    
    func checkExist(value: String?) -> Bool {
        if value == nil || value == "" {
            return false
        }
        return true
    }
    
    
}



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}