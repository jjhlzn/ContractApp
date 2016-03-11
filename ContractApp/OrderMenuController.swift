//
//  OrderMenuController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class OrderMenuController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var items = ["合同基本信息", "收购合同信息", "出运信息", "出厂付款信息", "收汇信息"]
    
    var order: Order!
    let orderService = OrderService()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderMenuCell")
        cell?.textLabel?.text = items[indexPath.row]
        cell?.textLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "basicInfoSegue" {
            let dest =  segue.destinationViewController as? OrderBasicInfoViewController
            dest?.basicInfo = sender as? OrderBasicInfo
        }
        if segue.identifier == "shougouSegue" {
            let dest = segue.destinationViewController as? OrderShougouInfoController
            dest?.shouGouInfo = sender as? OrderPurchaseInfo
        }
        
        if segue.identifier == "chuyunSegue" {
            let dest = segue.destinationViewController as? OrderChuyunInfoController
            dest?.chuyunInfo = sender as? OrderTransportInfo
        }
        
        if segue.identifier == "fukuangSegue" {
            let dest = segue.destinationViewController as? OrderFukuangInfoController
            dest?.fukuangInfo = sender as? OrderPurchaseInfo
        }
        
        if segue.identifier == "shouhuiSegue" {
            let dest = segue.destinationViewController as? OrderShouhuiController
            dest?.shouhuiInfo = sender as? OrderShouHuiInfo
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            loadingOverlay.showOverlay(self.view)
            orderService.getBasicInfo("") { response -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingOverlay.hideOverlayView()
                    if response.status != 0 {
                        self.displayMessage(response.errorMessage!)
                    } else {
                        self.performSegueWithIdentifier("basicInfoSegue", sender: response.basicInfo)
                    }
                }
            }

        }
        
        if indexPath.row == 1 {
            loadingOverlay.showOverlay(self.view)
            orderService.getOrderPurchaseInfo("") { response -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingOverlay.hideOverlayView()
                    if response.status != 0 {
                        self.displayMessage(response.errorMessage!)
                    } else {
                        self.performSegueWithIdentifier("shougouSegue", sender: response.orderPurchaseInfo)
                    }
                }
            }
        }
        
        if indexPath.row == 2 {
            loadingOverlay.showOverlay(self.view)
            orderService.getChuyunInfo("") { response -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingOverlay.hideOverlayView()
                    if response.status != 0 {
                        self.displayMessage(response.errorMessage!)
                    } else {
                        self.performSegueWithIdentifier("chuyunSegue", sender: response.chuyunInfo)
                    }
                }
                
            }
        }
        
        if indexPath.row == 3 {
            loadingOverlay.showOverlay(self.view)
            orderService.getFukuangInfo("") { response -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingOverlay.hideOverlayView()
                    if response.status != 0 {
                        self.displayMessage(response.errorMessage!)
                    } else {
                        self.performSegueWithIdentifier("fukuangSegue", sender: response.fukuangInfo)
                    }
                }
            }
        }
        
        if indexPath.row == 4 {
            loadingOverlay.showOverlay(self.view)
            orderService.getShouhuiInfo("") { response -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingOverlay.hideOverlayView()
                    if response.status != 0 {
                        self.displayMessage(response.errorMessage!)
                    } else {
                        self.performSegueWithIdentifier("shouhuiSegue", sender: response.shouhuiInfo)
                    }
                }
            }
        }
    }


}
