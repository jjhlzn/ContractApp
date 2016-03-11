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
        alertView.title = "系统提示"
        alertView.message = message
        alertView.addButtonWithTitle("好的")
        alertView.cancelButtonIndex=0
        alertView.delegate=self
        alertView.show()
        
    }

}
