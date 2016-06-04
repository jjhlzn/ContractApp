//
//  OrderListViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/27.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class CreatePriceReportViewController : BaseUIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var products = [Product]()
    
    var service = PriceReportService()
    
    
    var loginUserStore = LoginUserStore()
    
    var report : PriceReport!
    var codes : [String]!
    var submitSuccessDelegate : SubmitSuccessDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        submitSuccessDelegate = SubmitSuccessDelegate(controller: self)
        loadingOverlay.showOverlay(view)
        
        service.searchProducts(loginUserStore.GetLoginUser()!.userName!, codes: codes) {
            resp -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.loadingOverlay.hideOverlayView()
                
                if resp.status != 0 {
                    self.displayMessage("服务器出错")
                    return
                }
                
                self.products = resp.products
                self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let product = products[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("reportDetailCell") as! ReportDetailCell
        cell.idLabel.text = product.id
        cell.specificationLabel.text = product.specification
        cell.englishNameLabel.text = product.englishName
        
        return cell
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        displayConfirmMessage("确定提交吗？", delegate: self)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            submitReport()
            break;
        case 1:
            break;
        default:
            break;
        }
    }
    
    private func submitReport() {
        service.submitReport(loginUserStore.GetLoginUser()!.userName!, codes: codes) {
            resp -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if resp.status != 0 {
                    self.displayMessage(resp.errorMessage!)
                    return
                }
                self.report = resp.report!
                self.displayMessage("创建成功", delegate: self.submitSuccessDelegate)
            }
        }
    }

    
    class SubmitSuccessDelegate : NSObject, UIAlertViewDelegate {
        var controller: CreatePriceReportViewController
        init(controller: CreatePriceReportViewController) {
            self.controller = controller
        }
        func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
            let viewsToPop = 2
            var viewControllers = controller.navigationController?.viewControllers
            viewControllers?.removeLast(viewsToPop)
            let topController = viewControllers![0] as! PriceReportListViewController
            topController.pagableController.data.insert(controller.report, atIndex: 0)
            topController.tableView.reloadData()
            controller.navigationController?.setViewControllers(viewControllers!, animated: true)
            
        }
    }
   
    
}
