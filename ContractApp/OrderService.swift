//
//  OrderService.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/4/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation

class OrderService : BasicService{
    
    func search(userId: String, keyword: String, startDate: NSDate, endDate: NSDate, index: Int, pageSize: Int, completion: ((seachOrderResponse: SeachOrderResponse) -> Void)) -> SeachOrderResponse {
        let orderResponse = SeachOrderResponse()
        //make exception
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let parameters = ["userid": userId, "keyword": keyword, "startdate": formatter.stringFromDate(startDate), "enddate": formatter.stringFromDate(endDate), "index": "\(index)", "pagesize": "\(pageSize)"]
        sendRequest(ServiceConfiguration.SeachOrderUrl, parameters: parameters, serverResponse: orderResponse) { (dict) -> Void in
            if orderResponse.status == 0 {
                var orders = [Order]()
                let jsonOrders = dict["orders"] as! NSArray
                for jsonOrder in jsonOrders {
                    
                    let order = Order(id: jsonOrder["id"] as? String, businessPerson: jsonOrder["businessPerson"] as! String, contractNo: jsonOrder["contractNo"] as! String, orderNo: jsonOrder["orderNo"] as! String, amount: jsonOrder["amount"] as! NSNumber, guestName: jsonOrder["guestName"] as! String, moneyType: jsonOrder["moneyType"] as! String)
                    
                    orders.append(order)
                }
                orderResponse.orders = orders
                orderResponse.totalNumber = dict["totalNumber"] as! Int
            }
            completion(seachOrderResponse: orderResponse)
        }
        return orderResponse
    }
    
    
    
    //获取合同基本信息
    func getBasicInfo(orderId: String, completion: ((response: GetOrderBasicInfoResponse) -> Void)) -> GetOrderBasicInfoResponse {
        let response = GetOrderBasicInfoResponse()
        let parameters = ["orderId": orderId]
        sendRequest(ServiceConfiguration.GetBasicInfoUrl, parameters: parameters, serverResponse: response) { (dict) -> Void in
            if response.status == 0 {
                let json = dict["basicInfo"] as! NSDictionary
                let basicInfo = OrderBasicInfo(timeLimit: json["timeLimit"] as? String , startPort: json["startPort"] as? String, destPort: json["destPort"] as? String, getMoneyType: json["getMoneyType"] as? String, priceRule: json["priceRule"] as? String)
                response.basicInfo = basicInfo
            }
            completion(response: response)
        }
        return response
    }
    
    //获取合同收购信息
    func getOrderPurchaseInfo(orderId: String, completion: ((response: GetOrderPurchaseInfoResponse) -> Void)) -> GetOrderPurchaseInfoResponse {
        let response = GetOrderPurchaseInfoResponse()
        
        let parameters = ["orderId": orderId]
        sendRequest(ServiceConfiguration.GetOrderPurcaseInfoUrl, parameters: parameters, serverResponse: response) { (dict) -> Void in
            if response.status == 0 {
                let purchaseInfo = OrderPurchaseInfo()
                let jsonItems = dict["purchaseInfo"] as! NSArray
                var items = [OrderPurchaseItem]()
                for jsonItem in jsonItems {
                    let item = OrderPurchaseItem(contract: jsonItem["contract"] as? String, date: jsonItem["date"] as? String, factory: jsonItem["factory"] as? String, amount: jsonItem["amount"] as! NSNumber)
                    items.append(item)
                }
                purchaseInfo.items = items
                response.orderPurchaseInfo = purchaseInfo
            }
            completion(response: response)
        }
        return response
    }
    
    
    
    func getChuyunInfo(orderId: String, completion: ((response: GetOrderChuyunInfoResponse) -> Void)) -> GetOrderChuyunInfoResponse {
        let response = GetOrderChuyunInfoResponse()
        
        let parameters = ["orderId": orderId]
        sendRequest(ServiceConfiguration.GetOrderChuyunInfoUrl, parameters: parameters, serverResponse: response) { (dict) -> Void in
            if response.status == 0 {
                let json = dict["chuyunInfo"] as! NSDictionary
                let chuyunInfo = OrderTransportInfo(detailNo: json["detailNo"] as? String, date: json["date"] as? String, amount: json["amount"] as! NSNumber)
                response.chuyunInfo = chuyunInfo
            }
            completion(response: response)
        }
        return response
    }
    
    
    
    func getFukuangInfo(orderId: String, completion: ((response: GetOrderFukuangInfoResponse) -> Void)) -> GetOrderFukuangInfoResponse {
        let response = GetOrderFukuangInfoResponse()
        
        let parameters = ["orderId": orderId]
        sendRequest(ServiceConfiguration.GetOrderFukuangInfoUrl, parameters: parameters, serverResponse: response) { (dict) -> Void in
            if response.status == 0 {
                let purchaseInfo = OrderPurchaseInfo()
                let jsonItems = dict["fukuangInfo"] as! NSArray
                var items = [OrderPurchaseItem]()
                for jsonItem in jsonItems {
                    let item = OrderPurchaseItem(contract: jsonItem["contract"] as? String, date: jsonItem["date"] as? String, factory: jsonItem["factory"] as? String, amount: jsonItem["amount"] as! NSNumber)
                    items.append(item)
                }
                purchaseInfo.items = items
                response.fukuangInfo = purchaseInfo
            }
            completion(response: response)
        }
        return response
    }
    
    
    func getShouhuiInfo(orderId: String, completion: ((response: GetOrderShouhuiInfoResponse) -> Void)) -> GetOrderShouhuiInfoResponse {
        let response = GetOrderShouhuiInfoResponse()
        
        let parameters = ["orderId": orderId]
        sendRequest(ServiceConfiguration.GetOrderShouhuiInfoUrl, parameters: parameters, serverResponse: response) { (dict) -> Void in
            if response.status == 0 {
                let json = dict["shouhuiInfo"] as! NSDictionary
                let shouhuiInfo = OrderShouHuiInfo(date: json["date"] as? String, amount: json["amount"] as! NSNumber)
                response.shouhuiInfo = shouhuiInfo
            }
            completion(response: response)
        }
        return response
    }
    
}
