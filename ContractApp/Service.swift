//
//  Service.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation


class OrderService {
    
    func search(keyword: String?, startDate: NSDate?, endDate: NSDate?, index: Int, pageSize: Int, completion: ((seachOrderResponse: SeachOrderResponse) -> Void)) -> SeachOrderResponse {
        var orderResponse = SeachOrderResponse()
        var orders = [Order]()
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "http://localhost:3000/order/search.json"
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
                    
                    // Parse the JSON to get the IP
                    let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let jsonOrders = dict["orders"] as! NSArray
                    for jsonOrder in jsonOrders {
                        let order = Order(id: jsonOrder["id"] as? String, businessPerson: jsonOrder["businessPerson"] as! String, contractNo: jsonOrder["contractNo"] as! String, orderNo: jsonOrder["orderNo"] as! String, amount: jsonOrder["amount"] as! NSNumber, guestName: jsonOrder["guestName"] as! String)
                        orders.append(order)
                    }
                    orderResponse.orders = orders
                    orderResponse.totalNumber = dict["totalNumber"] as! Int
                                // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                    
                    completion(seachOrderResponse: orderResponse)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
        
        return orderResponse
    }
    
}