//
//  OrderListViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/27.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class PriceReportListViewController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, PagableControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var pagableController = PagableController<PriceReport>()
    var queryObject: PriceReportQueryObject?
    var service = PriceReportService()
    
    var loginUserStore = LoginUserStore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        pagableController.tableView = tableView
        pagableController.viewController = self
        pagableController.delegate = self
        pagableController.initController()
    
        if (queryObject == nil) {
            queryObject = createQueryObject()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if pagableController.checkIsNeedRefresh() {
            pagableController.refresh()
        }
    }
    
    
    private func createQueryObject() -> PriceReportQueryObject {
        let currentDateTime = NSDate()
        let tomorrow = currentDateTime.dateByAddingTimeInterval(24 * 60 * 60)
        //let oneMonthAgo = currentDateTime.dateByAddingTimeInterval(-10 * 12 * 31 * 24 * 60 * 60)
        let oneMonthAgo = currentDateTime.dateByAddingTimeInterval(-31 * 24 * 60 * 60)
        
        return PriceReportQueryObject(keyword: "", startDate: oneMonthAgo, endDate: tomorrow)
        
    }

    @IBAction func searchButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("searchPriceReportSegue", sender: nil)
    }
    


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pagableController.data.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let report = pagableController.data[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("priceReportCell") as! PriceReportCell
        cell.idLabel.text = report.id
        cell.dateLabel.text = report.date
        cell.statusLabel.text = report.status
        cell.detailLabel.text = report.detailInfo
        cell.reporterLabel.text = report.reporter

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("priceReportDetailSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "priceReportDetailSegue" {
            let dest = segue.destinationViewController as! PriceReportDetailViewController
            dest.report = pagableController.data[tableView.indexPathForSelectedRow!.row]
        } else if segue.identifier == "searchPriceReportSegue" {
            let dest = segue.destinationViewController as! PriceReportSearchViewController
            dest.queryObject = queryObject
        }
    }
    
    
    //开始上拉到特定位置后改变列表底部的提示
    func scrollViewDidScroll(scrollView: UIScrollView){
        pagableController.scrollViewDidScroll(scrollView)
    }
    
    
    //PageableControllerDelegate
    func searchHandler(respHandler: ((resp: ServerResponse) -> Void)) {
        
        service.search(loginUserStore.GetLoginUser()!.userName!, keyword: (queryObject?.keyword)!, startDate: (queryObject?.startDate)!, endDate: (queryObject?.endDate)!, index: pagableController.page, pageSize: (queryObject?.pageSize)!, completion: respHandler as ((resp: SearchPriceReportResponse) -> Void))
        

    }
    
    
    
    
    
    
}
