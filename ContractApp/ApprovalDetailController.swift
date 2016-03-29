//
//  ApprovalDetailController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/2.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class ApprovalDetailController: BaseUIViewController {
    
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
    
    var loginUser: LoginUser!
    let loginUserStore = LoginUserStore()

    
    var approval: Approval!
    let approvalService = ApprovalService()
    
    override func viewWillAppear(animated: Bool) {
        
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
            self.approvalResultLabel.text = "无"
        }
    }
    
    @IBAction func passPressed(sender: UIButton) {
        approve("0")
        
    }
    
    @IBAction func unpassPressed(sender: UIButton) {
        approve("-1")
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
                        self.displayMessage("审批成功")
                        self.approval.status = "已批"
                        self.statusLabel.text = "已批"
                        self.passButton.enabled = false
                        self.unpassButton.enabled = false
                        self.passButton.hidden = true
                        self.unpassButton.hidden = true
                    } else {
                        self.displayMessage("审批失败")
                    }
                    
                    if approvalResult == "0" {
                        self.approvalResultLabel.text = "批准"
                    } else {
                        self.approvalResultLabel.text = "不批准"
                    }
                }
            }
        }
    }

    


    
}
