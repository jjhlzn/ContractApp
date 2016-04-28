//
//  Service.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation

class ServiceConfiguration {
    //static let serverName = "localhost"
    static let httpMethod = "http"
    
    static let serverName21 = "jjhtest.hengdianworld.com"
    static let port21 = 3000
    
    static let serverName2 = "oa.lloydind.cn"
    static let port2 = 10443
    
    static var serverName: String {
        get {
            return serverName2
        }
    }
    
    static var port: Int {
        get {
            return port2
        }
    }

    
    static let SeachOrderUrl = "\(httpMethod)://\(serverName):\(port)/order/search.json"
    static let GetOrderPurcaseInfoUrl = "\(httpMethod)://\(serverName):\(port)/order/getPurchaseInfo.json"
    static let GetBasicInfoUrl = "\(httpMethod)://\(serverName):\(port)/order/getBasicInfo.json"
    static let GetOrderChuyunInfoUrl = "\(httpMethod)://\(serverName):\(port)/order/getChuyunInfo.json"
    static let GetOrderFukuangInfoUrl = "\(httpMethod)://\(serverName):\(port)/order/getFukuangInfo.json"
    static let GetOrderShouhuiInfoUrl = "\(httpMethod)://\(serverName):\(port)/order/getShouhuiInfo.json"

    static let SeachApprovalUrl = "\(httpMethod)://\(serverName):\(port)/approval/search.json"
    static let AuditApprovalUrl = "\(httpMethod)://\(serverName):\(port)/approval/audit.json"
    
    static let loginUrl = "\(httpMethod)://\(serverName):\(port)/login/login.json"
}

class BasicService {
    func sendRequest(url: String, serverResponse: ServerResponse, responseHandler: (dict: NSDictionary) -> Void) -> ServerResponse {
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        var postEndpoint: String = url
        let session = NSURLSession.sharedSession()
        print("send url: \(postEndpoint)")
        let url = NSURL(string: postEndpoint)!
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print(url)
                    print("Not a 200 response")
                    serverResponse.status = -1
                    serverResponse.errorMessage = "服务器返回出错"
                    responseHandler(dict: NSDictionary())
                    return
                }
            
            // Read the JSON
            do {
                if let jsonString = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(jsonString)
                    
                    let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    serverResponse.status = dict["status"] as! Int
                    if  serverResponse.status !=  0 {
                        return
                    }
                    
                    responseHandler(dict: dict)
                }
            } catch {
                print("bad things happened")
                serverResponse.status = -1
                serverResponse.errorMessage = "服务器结果处理异常"
                responseHandler(dict: NSDictionary())
                return
            }
        }).resume()

        return serverResponse
    }
}


class OrderService : BasicService{

    func search(keyword: String, startDate: NSDate, endDate: NSDate, index: Int, pageSize: Int, completion: ((seachOrderResponse: SeachOrderResponse) -> Void)) -> SeachOrderResponse {
        let orderResponse = SeachOrderResponse()
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = makeUrl(keyword, startDate: startDate, endDate: endDate, index: index, pageSize: pageSize)
        sendRequest(postEndpoint, serverResponse: orderResponse) { (dict) -> Void in
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
    
    func makeUrl(keyword: String, startDate: NSDate, endDate: NSDate, index: Int, pageSize: Int) -> String {
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let queryString = "keyword=\(keyword)&startdate=\(formatter.stringFromDate(startDate))&enddate=\(formatter.stringFromDate(endDate))&index=\(index)&pagesize=\(pageSize)"
        return ServiceConfiguration.SeachOrderUrl + "?" + queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    //获取合同基本信息
    func getBasicInfo(orderId: String, completion: ((response: GetOrderBasicInfoResponse) -> Void)) -> GetOrderBasicInfoResponse {
        let response = GetOrderBasicInfoResponse()
        let url = makeGetBasicInfoUrl(orderId)
        sendRequest(url, serverResponse: response) { (dict) -> Void in
            if response.status == 0 {
                let json = dict["basicInfo"] as! NSDictionary
                let basicInfo = OrderBasicInfo(timeLimit: json["timeLimit"] as? String , startPort: json["startPort"] as? String, destPort: json["destPort"] as? String, getMoneyType: json["getMoneyType"] as? String, priceRule: json["priceRule"] as? String)
                response.basicInfo = basicInfo
            }
            completion(response: response)
        }
        return response
    }
    
    func makeGetBasicInfoUrl(orderId: String) -> String {
        let queryString = "orderId=\(orderId)"
        return ServiceConfiguration.GetBasicInfoUrl + "?" + queryString

    }
    
    //获取合同收购信息
    func getOrderPurchaseInfo(orderId: String, completion: ((response: GetOrderPurchaseInfoResponse) -> Void)) -> GetOrderPurchaseInfoResponse {
        let response = GetOrderPurchaseInfoResponse()
        
        let url = makeGetOrderPurchaseInfoUrl(orderId)
        sendRequest(url, serverResponse: response) { (dict) -> Void in
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
    
    func makeGetOrderPurchaseInfoUrl(orderId: String) -> String {
        
        return ServiceConfiguration.GetOrderPurcaseInfoUrl + "?orderId=\(orderId)"
    }
    
    func getChuyunInfo(orderId: String, completion: ((response: GetOrderChuyunInfoResponse) -> Void)) -> GetOrderChuyunInfoResponse {
        let response = GetOrderChuyunInfoResponse()
        
        let url = makeGetOrderChuyunInfoUrl(orderId)
        sendRequest(url, serverResponse: response) { (dict) -> Void in
            if response.status == 0 {
                let json = dict["chuyunInfo"] as! NSDictionary
                let chuyunInfo = OrderTransportInfo(detailNo: json["detailNo"] as? String, date: json["date"] as? String, amount: json["amount"] as! NSNumber)
                response.chuyunInfo = chuyunInfo
            }
            completion(response: response)
        }
        return response
    }
    
    func makeGetOrderChuyunInfoUrl(orderId: String) -> String {
        return ServiceConfiguration.GetOrderChuyunInfoUrl + "?orderId=\(orderId)"
    }
    
    func getFukuangInfo(orderId: String, completion: ((response: GetOrderFukuangInfoResponse) -> Void)) -> GetOrderFukuangInfoResponse {
        let response = GetOrderFukuangInfoResponse()
        
        let url = makeGetOrderFukuangInfoUrl(orderId)
        sendRequest(url, serverResponse: response) { (dict) -> Void in
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
    
    func makeGetOrderFukuangInfoUrl(orderId: String) -> String {
        return ServiceConfiguration.GetOrderFukuangInfoUrl + "?orderId=\(orderId)"
    }
    
    func getShouhuiInfo(orderId: String, completion: ((response: GetOrderShouhuiInfoResponse) -> Void)) -> GetOrderShouhuiInfoResponse {
        let response = GetOrderShouhuiInfoResponse()
        
        let url = makeGetOrderShouhuiInfoUrl(orderId)
        sendRequest(url, serverResponse: response) { (dict) -> Void in
            if response.status == 0 {
                let json = dict["shouhuiInfo"] as! NSDictionary
                let shouhuiInfo = OrderShouHuiInfo(date: json["date"] as? String, amount: json["amount"] as! NSNumber)
                response.shouhuiInfo = shouhuiInfo
            }
            completion(response: response)
        }
        return response
    }
    
    func makeGetOrderShouhuiInfoUrl(orderId: String) -> String {
        return ServiceConfiguration.GetOrderShouhuiInfoUrl + "?orderId=\(orderId)"
    }
    
}

class ApprovalService : BasicService {
    func search(userId: String, keyword: String, containApproved: Bool, containUnapproved: Bool, startDate: NSDate, endDate: NSDate, index: Int, pageSize: Int, completion: ((searchApprovalResponse: SearchApprovalResponse) -> Void)) -> SearchApprovalResponse {
        let response = SearchApprovalResponse()
        let url = makeUrl(userId, keyword: keyword, containApproved: containApproved, containUnapproved: containUnapproved, startDate: startDate, endDate: endDate, index: index, pageSize: pageSize)
        sendRequest(url, serverResponse: response) { dict -> Void in
            if response.status == 0 {
                var approvals = [Approval]()
                let jsonApprovals = dict["approvals"] as! NSArray
                response.totalNumber = dict["totalNumber"] as! Int
                for jsonApproval in jsonApprovals {
                    let approval = Approval(id: (jsonApproval["id"] as? String)!, approvalObject: jsonApproval["approvalObject"] as? String, keyword: jsonApproval["keyword"] as! String, amount: jsonApproval["amount"] as! NSNumber, reporter: jsonApproval["reporter"] as! String, reportDate: jsonApproval["reportDate"] as! String, status: jsonApproval["status"] as? String, approvalResult: jsonApproval["approvalResult"] as? String, type: jsonApproval["type"] as? String)
                    approvals.append(approval)
                }
                response.approvals = approvals
            }
            completion(searchApprovalResponse: response)

        }
        return response
    }
    
    func makeUrl(userId: String, keyword: String, containApproved: Bool, containUnapproved: Bool, startDate: NSDate, endDate: NSDate, index: Int, pageSize: Int) -> String {
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let queryString = "userid=\(userId)&keyword=\(keyword)&containapproved=\(containApproved)&containunapproved=\(containUnapproved)&startdate=\(formatter.stringFromDate(startDate))&enddate=\(formatter.stringFromDate(endDate))&index=\(index)&pagesize=\(pageSize)"
        return ServiceConfiguration.SeachApprovalUrl + "?" + queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    func audit(userId: String, approvalId: String, result: String, completion: ((response: AuditApprovalResponse) -> Void)) -> AuditApprovalResponse {
        
        let response = AuditApprovalResponse()
        let url = makeAuditUrl(userId, approvalId: approvalId, result: result)
        sendRequest(url, serverResponse: response) { dict -> Void in
            if response.status == 0 {
                let json = dict["auditResult"] as! NSDictionary
                response.result = json["result"] as! Bool
                response.message = json["message"] as? String
            }
            completion(response: response)
        }
        return response
    }
    
    func makeAuditUrl(userId: String, approvalId: String, result: String) -> String {
        return ServiceConfiguration.AuditApprovalUrl + "?userid=\(userId)&result=\(result)&approvalid=\(approvalId)"
    }

}

class LoginService : BasicService {
    func login(userName: String, password: String, completion: ((loginResponse: LoginResponse) -> Void)) -> LoginResponse {
        let response = LoginResponse()
        let url = makeUrl(userName, password: password)
        sendRequest(url, serverResponse: response) { dict -> Void in
            if response.status == 0 {
                let jsonLoginResult = dict["result"] as! NSDictionary
                if jsonLoginResult["success"] as! Bool {
                    response.isSuccess = true
                    response.name = jsonLoginResult["name"] as? String
                    response.department = jsonLoginResult["department"] as? String
                } else {
                    response.isSuccess = false
                    response.errorMessage = jsonLoginResult["errorMessage"] as? String
                }
            }
            completion(loginResponse: response)
        }
        return response
    }
    
       
    func makeUrl(userName: String, password: String) -> String {
        let queryString = "x=\(userName)&y=\(password)"
        return ServiceConfiguration.loginUrl + "?" + queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
}