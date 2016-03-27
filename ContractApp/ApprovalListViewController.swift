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
    let tableFooterView = UIView()//列表的底部，用于显示“上拉查看更多”的提示，当上拉后显示类容为“松开加载更多”
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loginUser = loginUserStore.GetLoginUser()!
        
        tableView.dataSource = self
        tableView.delegate = self
        //if queryObject != nil && approvals.count > 9 {
            createTableFooter()
        //}
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.navigationController?.viewControllers.indexOf(self) == nil {
            ((self.parentViewController as! UINavigationController).topViewController as! ApprovalSearchController).queryObject = queryObject
        }
        super.viewWillAppear(animated)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approvals.count + 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCellWithIdentifier("approvalHeaderCell")!
        } else {
            let approval = approvals[indexPath.row - 1]
            let cell = tableView.dequeueReusableCellWithIdentifier("approvalContentCell") as! ApprovalCell
            cell.approvalObjectField.text = approval.approvalObject
            cell.keywordField.text = approval.keyword
            let amount = "\(Double(approval.amount).truncate(2))"
            cell.amountField.text = amount
            cell.reporterField.text = approval.reporter
            cell.reportDateField.text = approval.reportDate
            return cell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "approvalDetailSegue" {
            let dest = segue.destinationViewController as! ApprovalDetailController
            dest.approval = approvals[(tableView.indexPathForSelectedRow?.row)! - 1]
        }
    }
    
    func createTableFooter(){
        
        self.tableView.tableFooterView = nil
        
        tableFooterView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 40)
        loadMoreText.frame =  CGRectMake(0, 0, tableView.bounds.size.width, 40)
        loadMoreText.text = "上拉查看更多"
        
        loadMoreText.textAlignment = NSTextAlignment.Center
        tableFooterView.addSubview(loadMoreText)
        loadMoreText.font = UIFont(name: "Helvetica Neue", size: 15)
        loadMoreText.center = CGPointMake( (tableView.bounds.size.width - loadMoreText.intrinsicContentSize().width / 16) / 2 , 20)
        
        self.tableView.tableFooterView = tableFooterView
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
                    self.tableView.reloadData()
                    self.quering = false
                }
            }
            
        }
    }



}
