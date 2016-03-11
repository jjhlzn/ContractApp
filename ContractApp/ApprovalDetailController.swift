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
    
    var approval: Approval!
    let approvalService = ApprovalService()
    
    override func viewWillAppear(animated: Bool) {
        
        approvalObjectLabel.text = approval.approvalObject
        keywordLabel.text = approval.keyword
        amountLabel.text = "\(approval.amount)"
        reporterLabel.text = approval.reporter
        reportDateLabel.text = approval.reportDate
        statusLabel.text = approval.status
        
        if approval.status != "未审核" {
            passButton.enabled = false
            unpassButton.enabled = false
            self.passButton.hidden = true
            self.unpassButton.hidden = true

        }
    }
    
    @IBAction func passPressed(sender: UIButton) {
        if approval.status != "未审核" {
            return
        }
        self.loadingOverlay.showOverlay(self.view)
        approvalService.audit("", result: "pass") { response -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.loadingOverlay.hideOverlayView()
                if response.status != 0 {
                    self.displayMessage(response.errorMessage!)
                } else {
                    if response.result {
                        self.displayMessage("审核成功")
                        self.approval.status = "审核通过"
                        self.statusLabel.text = "审核通过"
                        self.passButton.enabled = false
                        self.unpassButton.enabled = false
                        self.passButton.hidden = true
                        self.unpassButton.hidden = true
                    } else {
                        self.displayMessage("审核失败")
                    }
                }
            }
        }
        
    }
    
    @IBAction func unpassPressed(sender: UIButton) {
        if approval.status != "未审核" {
            return
        }
        self.loadingOverlay.showOverlay(self.view)
        approvalService.audit("", result: "unpass") { response -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.loadingOverlay.hideOverlayView()
                if response.status != 0 {
                    self.displayMessage(response.errorMessage!)
                } else {
                    if response.result {
                        self.displayMessage("审核成功")
                        self.approval.status = "审核不通过"
                        self.statusLabel.text = "审核不通过"
                        self.passButton.enabled = false
                        self.unpassButton.enabled = false
                        self.passButton.hidden = true
                        self.unpassButton.hidden = true
                    } else {
                        self.displayMessage("审核失败")
                    }
                }
            }
        }
    }
    


    
}
