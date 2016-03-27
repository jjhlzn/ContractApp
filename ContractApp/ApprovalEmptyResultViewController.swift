//
//  ApprovalEmptyResultViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/26.
//  Copyright © 2016年 金军航. All rights reserved.
//
import UIKit

class ApprovalEmptyResultViewController: UIViewController {
    
    var queryObject: ApprovalQueryObject!
    
    override func viewWillDisappear(animated: Bool) {
        if self.navigationController?.viewControllers.indexOf(self) == nil {
            ((self.parentViewController as! UINavigationController).topViewController as! ApprovalSearchController).queryObject = queryObject
        }
        super.viewWillAppear(animated)
    }


}
