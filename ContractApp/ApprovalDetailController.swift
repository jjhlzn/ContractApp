//
//  ApprovalDetailController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/2.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class ApprovalDetailController: BaseUIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var approvalObjectLabel: UILabel!

    @IBOutlet weak var keywordLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var reporterLabel: UILabel!
    
    @IBOutlet weak var reportDateLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var passButton: UIButton!
    
    @IBOutlet weak var unpassButton: UIButton!
    
    @IBOutlet weak var approvalResultLabel: UILabel!
    
    @IBOutlet weak var approvalResultNameLabel: UILabel!
    
    var approvalSuccessAlertViewDelegate : ApprovalSuccessAlertViewDelegate?
    
    var isPassPressed: Bool = false
    var row: Int!
    
    var loginUser: LoginUser!
    let loginUserStore = LoginUserStore()

    
    var approval: Approval!
    let approvalService = ApprovalService()
    
    var isApprovedSuccess = false
    
    override func viewWillAppear(animated: Bool) {
        
        approvalSuccessAlertViewDelegate = ApprovalSuccessAlertViewDelegate(controller: self)
        loginUser = loginUserStore.GetLoginUser()!
        
        approvalObjectLabel.text = approval.approvalObject
        keywordLabel.text = approval.keyword
        amountLabel.text = "\(approval.amount)"
        reporterLabel.text = approval.reporter
        reportDateLabel.text = approval.reportDate
        statusLabel.text = approval.status
        approvalResultLabel.text = approval.approvalResult
        
        if approval.status != "待批" {
            passButton.enabled = false
            unpassButton.enabled = false
            self.passButton.hidden = true
            self.unpassButton.hidden = true
           
        } else {
             self.approvalResultLabel.text = "无"
        }
        //只要进入过这个页面就将badge设置为0
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("ApprovalDetailController#viewWillDisappear")
        if self.navigationController?.viewControllers.indexOf(self) == nil {
            let topController = (self.parentViewController as! UINavigationController).topViewController as! ApprovalListViewController
            let tableView = topController.tableView
            
            if isApprovedSuccess {
                topController.approvals.removeAtIndex(row)
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func passPressed(sender: UIButton) {
        isPassPressed = true
        displayConfirmMessage("确认批准吗？", delegate: self)
        
    }
    
    @IBAction func unpassPressed(sender: UIButton) {
        isPassPressed = false
        displayConfirmMessage("确认不批准吗？", delegate: self)
    }
    
    func approve(approvalResult: String) {
        if approval.status != "待批" {
            return
        }
        self.loadingOverlay.showOverlay(self.view)
        approvalService.audit(loginUser.userName!, approvalId: approval.id!, result: approvalResult) { response -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.loadingOverlay.hideOverlayView()
                if response.status != 0 {
                    self.displayMessage(response.errorMessage!)
                } else {
                    if response.result {
                        self.displayMessage("审批成功", delegate: self.approvalSuccessAlertViewDelegate!)
                        self.approval.status = "已批"
                        self.statusLabel.text = "已批"
                        self.passButton.enabled = false
                        self.unpassButton.enabled = false
                        self.passButton.hidden = true
                        self.unpassButton.hidden = true
                        
                        self.isApprovedSuccess = true
                    } else {
                        self.displayMessage("审批失败")
                    }
                    
                    if approvalResult == "0" {
                        self.approvalResultLabel.text = "批准"
                        self.approval.approvalResult = "批准"

                    } else {
                        self.approvalResultLabel.text = "不批准"
                        self.approval.approvalResult = "不批准"
                    }
                }
            }
        }
    }
    
    

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            if isPassPressed {
                approve("0")
            } else {
                approve("-1")
            }
            break;
        case 1:
            break;
        default:
            break;
        }
    }
    
    class ApprovalSuccessAlertViewDelegate : NSObject, UIAlertViewDelegate {
        
        var controller : UIViewController
        init(controller: UIViewController) {
            self.controller = controller
        }
        
        func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
            controller.navigationController?.popViewControllerAnimated(true)
        }
    }
}



