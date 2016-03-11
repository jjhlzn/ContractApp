//
//  OrderBasicInfoViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class OrderBasicInfoViewController: UIViewController {
    
    @IBOutlet weak var timeLimitLabel: UILabel!
    
    @IBOutlet weak var startPortLabel: UILabel!
    
    @IBOutlet weak var destPortLabel: UILabel!
    
    @IBOutlet weak var getMoneyTypeLabel: UILabel!
    
    @IBOutlet weak var priceRuleLabel: UILabel!
    var basicInfo: OrderBasicInfo!
    
    override func viewDidLoad() {
        timeLimitLabel.text = basicInfo.timeLimit
        startPortLabel.text = basicInfo.startPort
        destPortLabel.text = basicInfo.destPort
        getMoneyTypeLabel.text = basicInfo.getMoneyType
        priceRuleLabel.text = basicInfo.priceRule
    }

    @IBAction func backPressed(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
