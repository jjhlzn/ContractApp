//
//  BusinessModel.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/27.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation


class Order {
    var id : String?
    var businessPerson : String?
    var contractNo : String?
    var orderNo : String?
    var amount : NSNumber = 0.0
    var guestName : String?
    
    init(id: String?, businessPerson : String, contractNo : String, orderNo : String, amount : NSNumber, guestName : String) {
        self.id = id
        self.businessPerson = businessPerson
        self.contractNo = contractNo
        self.orderNo = orderNo
        self.amount = amount
        self.guestName = guestName
    }
}

class Approval {
    var id : String?
    var approvalObject: String?
    var keyword: String?
    var type: String?
    var amount: NSNumber = 0.0
    var reporter: String?
    var reportDate: String?
    var status: String?
    
    init(id: String, approvalObject: String?, keyword: String, amount: NSNumber, reporter: String, reportDate: String, status: String?) {
        self.id = id
        self.approvalObject = approvalObject
        self.keyword = keyword
        self.amount = amount
        self.reporter = reporter
        self.reportDate = reportDate
        self.status = status
    }
    
    init() {
        
    }
}

class ServerResponse  {
    var status : Int = 0
    var errorMessage : String?
}

class PageServerResponse : ServerResponse{
    var totalNumber : Int = 0
}

class SeachOrderResponse : PageServerResponse {
    var orders : [Order]!
    init(orders : [Order]) {
        self.orders = orders
    }
    override init() {
        
    }
}


class SearchApprovalResponse : PageServerResponse {
    var approvals = [Approval]()
    init(approvals: [Approval]) {
        self.approvals = approvals
    }
    override init() {
        
    }
}

class OrderQueryObject {
    var keyword: String?
    var startDate: NSDate?
    var endDate: NSDate?
    var pageSize: Int = 10
    
    init(keyword: String?, startDate: NSDate?, endDate: NSDate?)
    {
        self.keyword = keyword
        self.startDate = startDate
        self.endDate = endDate
    }
}

class ApprovalQueryObject {
    var keyword: String?
    var startDate: NSDate?
    var endDate: NSDate?
    var pageSize: Int = 10
    var containApproved: Bool = true
    var containUnapproved: Bool = true
    
    init(keyword: String?, startDate: NSDate?, endDate: NSDate?, containApproved: Bool, containUnapproved: Bool) {
        self.keyword = keyword
        self.startDate = startDate
        self.endDate = endDate
        self.containApproved = containApproved
        self.containUnapproved = containUnapproved
    }
}