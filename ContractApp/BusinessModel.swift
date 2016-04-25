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
    var moneyType : String?
    
    init(id: String?, businessPerson : String, contractNo : String, orderNo : String, amount : NSNumber, guestName : String, moneyType : String) {
        self.id = id
        self.businessPerson = businessPerson
        self.contractNo = contractNo
        self.orderNo = orderNo
        self.amount = amount
        self.guestName = guestName
        self.moneyType = moneyType
    }
    init() {
        
    }
}

//合同基本信息
class OrderBasicInfo {
    var timeLimit: String?
    var startPort: String?
    var destPort: String?
    var getMoneyType: String?
    var priceRule: String?
    
    init(timeLimit: String?, startPort: String?, destPort: String?, getMoneyType: String?, priceRule: String?) {
        self.timeLimit = timeLimit
        self.startPort = startPort
        self.destPort = destPort
        self.getMoneyType = getMoneyType
        self.priceRule = priceRule
    }
}

//合同收购信息, 工厂付款信息
class OrderPurchaseInfo {
    var items = [OrderPurchaseItem]()
}

class OrderPurchaseItem {
    var contract: String?
    var date: String?
    var factory: String?
    var amount: NSNumber = 0.0
    
    init(contract: String?, date: String?, factory: String?, amount: NSNumber) {
        self.contract = contract
        self.date = date
        self.factory = factory
        self.amount = amount
    }
}

//订单出运信息
class OrderTransportInfo {
    var detailNo: String?
    var date: String?
    var amount: NSNumber = 0.0
    
    init(detailNo: String?, date: String?, amount: NSNumber) {
        self.detailNo = detailNo
        self.date = date
        self.amount = amount
    }
}

//收汇信息
class OrderShouHuiInfo {
    var date: String?
    var amount: NSNumber = 0.0
    
    init(date: String?, amount: NSNumber) {
        self.date = date
        self.amount = amount
    }
}

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
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
    var approvalResult: String?
    
    init(id: String, approvalObject: String?, keyword: String, amount: NSNumber, reporter: String, reportDate: String, status: String?, approvalResult: String?, type: String?) {
        self.id = id
        self.approvalObject = approvalObject
        self.keyword = keyword
        self.amount = amount
        self.reporter = reporter
        self.reportDate = reportDate
        self.status = status
        self.approvalResult = approvalResult
        self.type = type
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

class QueryObject {
    
}

class OrderQueryObject : QueryObject {
    var keyword: String
    var startDate: NSDate
    var endDate: NSDate
    var pageSize: Int = 10
    
    init(keyword: String, startDate: NSDate, endDate: NSDate)
    {
        self.keyword = keyword
        self.startDate = startDate
        self.endDate = endDate
    }
}

class ApprovalQueryObject : QueryObject {
    var keyword: String
    var startDate: NSDate
    var endDate: NSDate
    var pageSize: Int = 10
    var containApproved: Bool = true
    var containUnapproved: Bool = true
    
    init(keyword: String, startDate: NSDate, endDate: NSDate, containApproved: Bool, containUnapproved: Bool) {
        self.keyword = keyword
        self.startDate = startDate
        self.endDate = endDate
        self.containApproved = containApproved
        self.containUnapproved = containUnapproved
    }
}

class LoginResponse : ServerResponse {
    var isSuccess : Bool = false
    var errMessage: String?
    var name : String?
    var department : String?
    
    init(isSuccess: Bool, name: String?, department: String?) {
        self.isSuccess = isSuccess
        self.name = name
        self.department = department
    }
    
    override init() {
        
    }
}

class GetOrderPurchaseInfoResponse : ServerResponse {
    var orderPurchaseInfo: OrderPurchaseInfo?
}

class GetOrderBasicInfoResponse : ServerResponse {
    var basicInfo: OrderBasicInfo?
}

class GetOrderChuyunInfoResponse : ServerResponse {
    var chuyunInfo: OrderTransportInfo?
}

class GetOrderFukuangInfoResponse : ServerResponse {
    var fukuangInfo: OrderPurchaseInfo?
}

class GetOrderShouhuiInfoResponse : ServerResponse {
    var shouhuiInfo: OrderShouHuiInfo?
}

class AuditApprovalResponse : ServerResponse {
    var result: Bool = false
    var message: String?
    
}