//
//  OrderListViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/27.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var orders = [Order]()
    var orderService = OrderService()
    var queryObject: OrderQueryObject?
    var hasMore = false
    var page = 0
    
    var loadMoreText = UILabel()
    let tableFooterView = UIView()//列表的底部，用于显示“上拉查看更多”的提示，当上拉后显示类容为“松开加载更多”
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //orders = orderService.search()
        //print("orders.count = \(orders.count)")
        /*
        for index in 1...10 {
            let order = Order(id: "11", businessPerson: "金军航\(index)", contractNo : "14KB00000178", orderNo: "14-02315", amount: 34177.08, guestName: "中国移动公司")
            orders.append(order)
        }*/
        
        tableView.dataSource = self
        tableView.delegate = self
        if queryObject != nil && orders.count > 9 {
            createTableFooter()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count + 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCellWithIdentifier("orderHeaderCell")!
        } else {
            let order = orders[indexPath.row - 1]
            let cell = tableView.dequeueReusableCellWithIdentifier("orderContentCell") as! OrderCell
            cell.businessPersonLabel.text = order.businessPerson
            cell.orderNoLabel.text = order.orderNo
            cell.guestNameLabel.text = order.guestName
            cell.contractNoLabel.text = order.contractNo
            cell.amountLabel.text = "\(order.amount)"
            return cell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "orderMenuSegue" {
            let dest = segue.destinationViewController as! OrderMenuController
            
            dest.order = orders[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func createTableFooter(){//初始化tv的footerView
        
        self.tableView.tableFooterView = nil
        
        tableFooterView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 60)
        loadMoreText.frame =  CGRectMake(0, 0, tableView.bounds.size.width, 60)
        loadMoreText.text = "上拉查看更多"
        
        loadMoreText.textAlignment = NSTextAlignment.Center
        
        tableFooterView.addSubview(loadMoreText)
        
        tableView.tableFooterView = tableFooterView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){//开始上拉到特定位置后改变列表底部的提示
        if !hasMore {
            loadMoreText.text = "已加载全部数据"
            return
        }
        
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + 30){
            loadMoreText.text = "松开载入更多"
            
        }else{
            loadMoreText.text = "上拉查看更多"
            
        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool){
        
        if !hasMore {
            return
        }
        
        loadMoreText.text = "上拉查看更多"
        
        /*上拉到一定程度松开后开始加载更多*/
        
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + 30){
            
            //self.initArr()
            orderService.search(queryObject?.keyword, startDate: queryObject?.startDate, endDate: queryObject?.endDate, index: page * (queryObject?.pageSize)!, pageSize: (queryObject?.pageSize)!) {
                orderResponse in
                dispatch_async(dispatch_get_main_queue()) {
                    self.page++
                    let newOrders = orderResponse.orders
                    for order in newOrders {
                        self.orders.append(order)
                    }
                    if self.orders.count >= orderResponse.totalNumber {
                        self.hasMore = true
                    }
                }
            }
            self.tableView.reloadData()
        }
    }

}
