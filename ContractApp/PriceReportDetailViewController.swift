//
//  OrderListViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/27.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class PriceReportDetailViewController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, PagableControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var pagableController = PagableController<Product>()

    var service = PriceReportService()
    
    var loginUserStore = LoginUserStore()
    
    var report : PriceReport!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        pagableController.tableView = tableView
        pagableController.viewController = self
        pagableController.delegate = self
        pagableController.initController()

    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pagableController.data.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let product = pagableController.data[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("reportDetailCell") as! ReportDetailCell
        cell.idLabel.text = product.id
        cell.specificationLabel.text = product.specification
        cell.priceLabel.text = "\(product.moneyType)\(String(format:"%.2f", Double(product.price)))"
        cell.englishNameLabel.text = product.englishName
        
        return cell
    }
    
    
    
    //开始上拉到特定位置后改变列表底部的提示
    func scrollViewDidScroll(scrollView: UIScrollView){
        pagableController.scrollViewDidScroll(scrollView)
    }
    
    
    //PageableControllerDelegate
    func searchHandler(respHandler: ((resp: ServerResponse) -> Void)) {
        
        service.getPriceReport(loginUserStore.GetLoginUser()!.userName!, reportId: report.id, index: pagableController.page, pageSize: 20, completion: respHandler as ((resp: GetPriceReportResonse) -> Void))
        
        
    }
    
    
}
