//
//  Service.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation

class ServiceConfiguration {
    static let serverName = "localhost"
    static let port = 3000
    static let SeachOrderUrl = "http://\(serverName):\(port)/order/search.json"
    static let SeachApprovalUrl = "http://\(serverName):\(port)/approval/search.json"
}

class BasicService {
    func sendRequest(url: String, serverResponse: ServerResponse, responseHandler: (dict: NSDictionary) -> Void) -> ServerResponse {
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = url
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                if let ipString = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(ipString)
                    
                    let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    responseHandler(dict: dict)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()

        return serverResponse
    }
}


class OrderService : BasicService{

    func search(keyword: String?, startDate: NSDate?, endDate: NSDate?, index: Int, pageSize: Int, completion: ((seachOrderResponse: SeachOrderResponse) -> Void)) -> SeachOrderResponse {
        let orderResponse = SeachOrderResponse()
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = makeUrl(keyword, startDate: startDate, endDate: endDate, index: index, pageSize: pageSize)
        sendRequest(postEndpoint, serverResponse: orderResponse) { (dict) -> Void in
            var orders = [Order]()
            let jsonOrders = dict["orders"] as! NSArray
            for jsonOrder in jsonOrders {
                let order = Order(id: jsonOrder["id"] as? String, businessPerson: jsonOrder["businessPerson"] as! String, contractNo: jsonOrder["contractNo"] as! String, orderNo: jsonOrder["orderNo"] as! String, amount: jsonOrder["amount"] as! NSNumber, guestName: jsonOrder["guestName"] as! String)
                orders.append(order)
            }
            orderResponse.orders = orders
            orderResponse.totalNumber = dict["totalNumber"] as! Int
            
            completion(seachOrderResponse: orderResponse)
        }
        return orderResponse
    }
    
    func makeUrl(keyword: String?, startDate: NSDate?, endDate: NSDate?, index: Int, pageSize: Int) -> String {
        return ServiceConfiguration.SeachOrderUrl
    }
    
}

class ApprovalService : BasicService {
    func search(keyword: String?, containApproved: Bool, containUnapproved: Bool, startDate: NSDate?, endDate: NSDate?, index: Int, pageSize: Int, completion: ((searchApprovalResponse: SearchApprovalResponse) -> Void)) -> SearchApprovalResponse {
        let response = SearchApprovalResponse()
        let url = makeUrl(keyword, containApproved: containApproved, containUnapproved: containUnapproved, startDate: startDate, endDate: endDate, index: index, pageSize: pageSize)
        sendRequest(url, serverResponse: response) { dict -> Void in
            var approvals = [Approval]()
            let jsonApprovals = dict["approvals"] as! NSArray
            for jsonApproval in jsonApprovals {
                let approval = Approval(id: (jsonApproval["id"] as? String)!, approvalObject: jsonApproval["approvalObject"] as? String, keyword: jsonApproval["keyword"] as! String, amount: jsonApproval["amount"] as! NSNumber, reporter: jsonApproval["reporter"] as! String, reportDate: jsonApproval["reportDate"] as! String, status: jsonApproval["status"] as? String)
                approvals.append(approval)
            }
            response.approvals = approvals
            completion(searchApprovalResponse: response)

        }
        return response
    }
    
    func makeUrl(keyword: String?, containApproved: Bool, containUnapproved: Bool, startDate: NSDate?, endDate: NSDate?, index: Int, pageSize: Int) -> String {
        return ServiceConfiguration.SeachApprovalUrl
    }

}