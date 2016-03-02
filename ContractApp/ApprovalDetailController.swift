//
//  ApprovalDetailController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/2.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class ApprovalDetailController: UIViewController {
    
    
    @IBOutlet weak var approvalObjectLabel: UILabel!

    @IBOutlet weak var keywordLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var reporterLabel: UILabel!
    
    @IBOutlet weak var reportDateLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var approval: Approval!
    
    override func viewWillAppear(animated: Bool) {
        
        approvalObjectLabel.text = approval.approvalObject
        keywordLabel.text = approval.keyword
        amountLabel.text = "\(approval.amount)"
        reporterLabel.text = approval.reporter
        reportDateLabel.text = approval.reportDate
        statusLabel.text = approval.status
    }
    
    @IBAction func passPressed(sender: UIButton) {
    }
    
    @IBAction func unpassPressed(sender: UIButton) {
    }
    
    
}
