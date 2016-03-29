//
//  OrderChuyunInfoController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/6.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class OrderChuyunInfoController: UIViewController {
    
    @IBOutlet weak var detailNoLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    var chuyunInfo: OrderTransportInfo!

    override func viewDidLoad() {
        super.viewDidLoad()

        detailNoLabel.text = chuyunInfo.detailNo
        dateLabel.text = chuyunInfo.date
        amountLabel.text = "¥\(String(format:"%.2f", Double(chuyunInfo.amount)))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
