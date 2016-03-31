//
//  ApprovalListViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/1.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class ApprovalListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var approvals = [Approval]()
    var approvalService = ApprovalService()
    var queryObject: ApprovalQueryObject?
    var hasMore = false
    var quering = false
    var page = 1
    
    var loginUser: LoginUser!
    let loginUserStore = LoginUserStore()
    
    
    var loadMoreText = UILabel()
    var tableFooterView = UIView()//列表的底部，用于显示“上拉查看更多”的提示，当上拉后显示类容为“松开加载更多”
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loginUser = loginUserStore.GetLoginUser()!
        
        tableView.dataSource = self
        tableView.delegate = self
        createTableFooter()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.navigationController?.viewControllers.indexOf(self) == nil {
            ((self.parentViewController as! UINavigationController).topViewController as! ApprovalSearchController).queryObject = queryObject
            
        }
        super.viewWillAppear(animated)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approvals.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let approval = approvals[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("approvalContentCell") as! ApprovalCell
        cell.approvalObjectField.text = approval.approvalObject
        cell.keywordField.text = approval.keyword
        let amount = "¥\(String(format:"%.2f", Double(approval.amount)))"
        cell.amountField.text = amount
        cell.reporterField.text = approval.reporter
        cell.reportDateField.text = approval.reportDate
        cell.typeField.text = approval.type
        if approval.status == "已批" && approval.approvalResult != nil {
            cell.statusField.text = approval.approvalResult!
        } else {
            cell.statusField.text = approval.status
        }
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "approvalDetailSegue" {
            let dest = segue.destinationViewController as! ApprovalDetailController
            dest.approval = approvals[(tableView.indexPathForSelectedRow?.row)!]
        }
    }


    
    func createTableFooter(){//初始化tv的footerView
        setNotLoadFooter()
    }
    
    func setNotLoadFooter() {
        self.tableView.tableFooterView = nil
        tableFooterView = UIView()
        tableFooterView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 40)
        loadMoreText.frame =  CGRectMake(0, 0, tableView.bounds.size.width, 40)
        loadMoreText.text = "上拉查看更多"
        
        loadMoreText.textAlignment = NSTextAlignment.Center
        loadMoreText.textColor = UIColor.grayColor()
        tableFooterView.addSubview(loadMoreText)
        loadMoreText.font = UIFont(name: "Helvetica Neue", size: 10)
        loadMoreText.center = CGPointMake( (tableView.bounds.size.width - loadMoreText.intrinsicContentSize().width / 16) / 2 , 20)
        
        
        tableView.tableFooterView = tableFooterView
    }
    
    func setLoadingFooter() {
        self.tableView.tableFooterView = nil
        tableFooterView = UIView()
        tableFooterView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 40)
        loadMoreText.frame =  CGRectMake(0, 0, tableView.bounds.size.width, 40)
        loadMoreText.text = "加载中"
        
        loadMoreText.textAlignment = NSTextAlignment.Center
        
        
        
        loadMoreText.font = UIFont(name: "Helvetica Neue", size: 10)
        loadMoreText.textColor = UIColor.grayColor()
        loadMoreText.center = CGPointMake( (tableView.bounds.size.width - loadMoreText.intrinsicContentSize().width / 16) / 2 , 20)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = CGPointMake( (tableView.bounds.size.width - 80 - loadMoreText.intrinsicContentSize().width / 16) / 2 , 20)
        activityIndicator.startAnimating()
        
        tableFooterView.addSubview(activityIndicator)
        tableFooterView.addSubview(loadMoreText)
        
        tableView.tableFooterView = tableFooterView
    }
    
    
    //开始上拉到特定位置后改变列表底部的提示
    func scrollViewDidScroll(scrollView: UIScrollView){
        if quering {
            return
        }
        
        if !hasMore {
            loadMoreText.text = "已加载全部数据"
            return
        }
        //print("scrollView.contentOffset.y = \(scrollView.contentOffset.y)")
        //print("scrollView.contentSize.height = \(scrollView.contentSize.height)")
        //print("scrollView.frame.size.height = \(scrollView.frame.size.height)")
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height ){
            
            loadMore()
        }
    }
    
    
    func loadMore() {
        quering = true
        print("loading")
        //loadMoreText.text = "正在加载中"
        setLoadingFooter()
        //self.initArr()
        
        approvalService.search(loginUser.userName!, keyword: (queryObject?.keyword)!, containApproved: (queryObject?.containApproved)!, containUnapproved: (queryObject?.containUnapproved)!, startDate: (queryObject?.startDate)!, endDate: (queryObject?.endDate)!, index: page, pageSize: (queryObject?.pageSize)!) { response in
            dispatch_async(dispatch_get_main_queue()) {
                self.page = self.page + 1
                let newApprovals = response.approvals
                for approval in newApprovals {
                    self.approvals.append(approval)
                }
                if self.approvals.count >= response.totalNumber {
                    self.hasMore = false
                }
                
                self.setNotLoadFooter()
                if self.hasMore {
                    self.loadMoreText.text = "上拉查看更多"
                } else {
                    self.loadMoreText.text = "已加载全部数据"
                }
                
                self.tableView.reloadData()
                self.quering = false
                
            }
        }
        
    }


    


}
