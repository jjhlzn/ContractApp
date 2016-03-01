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

class ServerResponse {
    var status : Int = 0
    var errorMessage : String?
}

class PageServerResponse {
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