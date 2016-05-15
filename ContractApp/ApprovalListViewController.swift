//
//  ApprovalListViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/1.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class ApprovalListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let UPDATETIEM = 5.0 * 60
    
    @IBOutlet weak var tableView: UITableView!
    
    var loadingOverlay = LoadingOverlay()

    var approvals = [Approval]()
    var approvalService = ApprovalService()
    var queryObject: ApprovalQueryObject?
    var hasMore = true
    var quering = false
    var page = 0
    
    var firstLoad = true
    var userName: String!
    var loginUser: LoginUser!
    let loginUserStore = LoginUserStore()
    
    
    var loadMoreText = UILabel()
    var tableFooterView = UIView()//列表的底部，用于显示“上拉查看更多”的提示，当上拉后显示类容为“松开加载更多”
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        print("viewDidLoad")
        loginUser = loginUserStore.GetLoginUser()!
        userName = loginUser.userName
        tableView.dataSource = self
        tableView.delegate = self
        
        if (queryObject == nil) {
            queryObject = createQueryObject()
        }


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        print("approvals.count = \(approvals.count)")
        createTableFooter()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !firstLoad {
            if needRefreshForTimeout() {
                page = 0
                hasMore = true
                quering = false
                print("need refresh")
                refresh(1)
            }
        }
        
        firstLoad = false
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("approvals.count = \(approvals.count)")
    }
    
    private func needRefreshForTimeout() -> Bool {
        loginUser = loginUserStore.GetLoginUser()
        if (loginUser.lastUpdateApproval == nil) {
            return false
        }
        
        let lastUpdate = loginUser.lastUpdateApproval!
        let currentDateTime = NSDate()
        let delta = currentDateTime.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970
        print("delta = \(delta)")
        return delta > UPDATETIEM
    }
    
    func refresh(sender:AnyObject) {
        refreshControl.endRefreshing()
        refreshControl.endRefreshing()
        if (quering) {
            refreshControl.endRefreshing()
            return
        }
        quering = true

        self.page = 0
        print("refreshing")
        
        approvalService.search(loginUser.userName!, keyword: (queryObject?.keyword)!, containApproved: (queryObject?.containApproved)!, containUnapproved: (queryObject?.containUnapproved)!, startDate: (queryObject?.startDate)!, endDate: (queryObject?.endDate)!, index: page, pageSize: (queryObject?.pageSize)!) { response in
            dispatch_async(dispatch_get_main_queue()) {
                if self.page == 0 {
                    self.loginUserStore.updateApprovalUpdateTime(self.loginUser, time: NSDate())
                }
                self.refreshControl.endRefreshing()
                self.quering = false
                if response.status != 0 {
                    return
                }
                self.page = self.page + 1
                self.approvals = response.approvals
                
                if self.approvals.count >= response.totalNumber {
                    self.hasMore = false
                }
                
                self.setNotLoadFooter()
                
                
                self.tableView.reloadData()
                
                self.setFootText()
            }
        }

    }
    
    
    
    private func createQueryObject() -> ApprovalQueryObject {
        let currentDateTime = NSDate()
        let tomorrow = currentDateTime.dateByAddingTimeInterval(24 * 60 * 60)
        //let oneMonthAgo = currentDateTime.dateByAddingTimeInterval(-10 * 12 * 31 * 24 * 60 * 60)
        let oneMonthAgo = currentDateTime.dateByAddingTimeInterval(-31 * 24 * 60 * 60)
        
        let queryObject = ApprovalQueryObject()
        queryObject.keyword = ""
        queryObject.startDate = oneMonthAgo
        queryObject.endDate = tomorrow
        queryObject.containApproved = false
        queryObject.containUnapproved = true
        return queryObject
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
            dest.row = (tableView.indexPathForSelectedRow?.row)!
        } else if segue.identifier == "searchApprovalSegue" {
            let dest = segue.destinationViewController as! ApprovalSearchController
            dest.queryObject = queryObject
        }
    }


    private func createTableFooter(){//初始化tv的footerView
        setNotLoadFooter()
    }
    
    private func setNotLoadFooter() {
        self.tableView.tableFooterView = nil
        tableFooterView = UIView()
        tableFooterView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 40)
        loadMoreText.frame =  CGRectMake(0, 0, tableView.bounds.size.width, 40)
        
        
        loadMoreText.textAlignment = NSTextAlignment.Center
        tableFooterView.addSubview(loadMoreText)
        loadMoreText.center = CGPointMake( (tableView.bounds.size.width - loadMoreText.intrinsicContentSize().width / 16) / 2 , 20)
        self.setFootText()
        
        tableView.tableFooterView = tableFooterView
    }
    
    private func setFootText() {
        loadMoreText.font = UIFont(name: "Helvetica Neue", size: 10)
        loadMoreText.textColor = UIColor.grayColor()
        if quering {
            self.loadMoreText.text = "加载中"
            
        } else {
            if self.hasMore {
                self.loadMoreText.text = "上拉查看更多"
            } else {
                if self.approvals.count == 0 {
                    loadMoreText.font = UIFont(name: "Helvetica Neue", size: 14)
                    self.loadMoreText.text = "没找到任何审批"
                } else {
                    
                    self.loadMoreText.text = "已加载全部数据"
                }
            }
        }
    }
    
    
    func setLoadingFooter() {
        self.tableView.tableFooterView = nil
        tableFooterView = UIView()
        tableFooterView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 40)
        loadMoreText.frame =  CGRectMake(0, 0, tableView.bounds.size.width, 40)
        
        
        loadMoreText.textAlignment = NSTextAlignment.Center
        
        
        loadMoreText.center = CGPointMake( (tableView.bounds.size.width - loadMoreText.intrinsicContentSize().width / 16) / 2 , 20)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = CGPointMake( (tableView.bounds.size.width - 80 - loadMoreText.intrinsicContentSize().width / 16) / 2 , 20)
        activityIndicator.startAnimating()
        
        tableFooterView.addSubview(activityIndicator)
        tableFooterView.addSubview(loadMoreText)
        setFootText()
        tableView.tableFooterView = tableFooterView
    }
    
    
    //开始上拉到特定位置后改变列表底部的提示
    func scrollViewDidScroll(scrollView: UIScrollView){
        if quering {
            return
        }
        setFootText()
        if !hasMore {
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
        setLoadingFooter()
        
        approvalService.search(userName, keyword: (queryObject?.keyword)!, containApproved: (queryObject?.containApproved)!, containUnapproved: (queryObject?.containUnapproved)!, startDate: (queryObject?.startDate)!, endDate: (queryObject?.endDate)!, index: page, pageSize: (queryObject?.pageSize)!) { response in
            dispatch_async(dispatch_get_main_queue()) {
                if self.page == 0 {
                    self.loginUserStore.updateApprovalUpdateTime(self.loginUser, time: NSDate())
                }
                
                self.page = self.page + 1
                let newApprovals = response.approvals
                for approval in newApprovals {
                    self.approvals.append(approval)
                }
                if self.approvals.count >= response.totalNumber {
                    self.hasMore = false
                }
                
                self.setNotLoadFooter()
                
                
                self.tableView.reloadData()
                self.quering = false
                self.setFootText()
            }
        }
        
    }


    


}
