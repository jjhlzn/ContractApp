//
//  OrderFukuangInfoController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/6.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class OrderFukuangInfoController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var fukuangInfo: OrderPurchaseInfo?
    
    let orderService = OrderService()
    var orderId : String?
    
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func backPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fukuangInfo?.items.count == 0 ? 1 : (fukuangInfo?.items.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if fukuangInfo?.items.count == 0 {
            return tableView.dequeueReusableCellWithIdentifier("shougouHeaderCell")!
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("shougouContentCell") as! OrderPurchaseInfoCell
            let item = fukuangInfo?.items[indexPath.row]
            cell.contractLabel.text = item?.contract
            cell.dateLabel.text = item?.date == nil ? "" : item?.date!.stringByReplacingOccurrencesOfString("/", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
            cell.factoryLabel.text = item?.factory
            if item?.amount != nil {
                cell.amountLabel.text = "¥\(String(format: "%.2f", Double((item?.amount)!)))"
            }
            return cell
        }
    }

}
