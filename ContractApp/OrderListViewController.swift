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
    var page = 1
    var quering = false
    
    var loadMoreText = UILabel()
    let tableFooterView = UIView()//列表的底部，用于显示“上拉查看更多”的提示，当上拉后显示类容为“松开加载更多”
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.dataSource = self
        tableView.delegate = self
        createTableFooter()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.navigationController?.viewControllers.indexOf(self) == nil {
            ((self.parentViewController as! UINavigationController).topViewController as! OrderSearchViewController).queryObject = queryObject
        }
        super.viewWillAppear(animated)
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

            let order = orders[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("orderContentCell") as! OrderCell
            cell.businessPersonLabel.text = order.businessPerson
            cell.orderNoLabel.text = order.orderNo
            cell.guestNameLabel.text = order.guestName
            cell.contractNoLabel.text = order.contractNo
            cell.amountLabel.text = "¥\(order.amount)"
            return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "orderMenuSegue" {
            let dest = segue.destinationViewController as! OrderMenuController
            dest.order = orders[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func createTableFooter(){//初始化tv的footerView
        
        self.tableView.tableFooterView = nil
        
        tableFooterView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 40)
        loadMoreText.frame =  CGRectMake(0, 0, tableView.bounds.size.width, 40)
        loadMoreText.text = "上拉查看更多"
        
        loadMoreText.textAlignment = NSTextAlignment.Center
        tableFooterView.addSubview(loadMoreText)
        loadMoreText.font = UIFont(name: "Helvetica Neue", size: 15)
        loadMoreText.center = CGPointMake( (tableView.bounds.size.width - loadMoreText.intrinsicContentSize().width / 16) / 2 , 20)
        
        
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
        
        if quering {
            return
        }
        
        loadMoreText.text = "上拉查看更多"
        
        /*上拉到一定程度松开后开始加载更多*/
        
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + 30){
            
            loadMoreText.text = "加载中"
            //self.initArr()
            quering = true
            orderService.search((queryObject?.keyword)!, startDate: (queryObject?.startDate)!, endDate: (queryObject?.endDate)!, index: page, pageSize: (queryObject?.pageSize)!) {
                orderResponse in
                dispatch_async(dispatch_get_main_queue()) {
                    self.page = self.page + 1
                    let newOrders = orderResponse.orders
                    for order in newOrders {
                        self.orders.append(order)
                    }
                    if self.orders.count >= orderResponse.totalNumber {
                        self.hasMore = false
                    }
                    self.tableView.reloadData()
                    self.quering = false
                }
            }
            
        }
    }

}
