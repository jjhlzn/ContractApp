//
//  OrderShouhuiController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/6.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class OrderShouhuiController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    var shouhuiInfo: OrderShouHuiInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = shouhuiInfo.date
        amountLabel.text = "¥\(String(format: "%.2f", Double(shouhuiInfo.amount)))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

  
}
