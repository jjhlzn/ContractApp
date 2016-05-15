//
//  BasicService.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/4/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation

enum HttpMethod {
    case GET
    case POST
}

class BasicService : NSObject, NSURLSessionDelegate {
    //处理https
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust{
            let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential,credential);
        }
        
    }
    
    func sendRequest(url: String, parameters: [String: String] = [String: String](),  serverResponse: ServerResponse, responseHandler: (dict: NSDictionary) -> Void) -> ServerResponse {
        var postEndpoint: String = url
        let session =  NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                                    delegate: self,
                                    delegateQueue: nil)
        
        // Make the POST call and handle it in a completion handler
        let request: NSMutableURLRequest!
        
        let method = HttpMethod.POST
        if method == HttpMethod.POST {
            request = NSMutableURLRequest(URL: NSURL(string: postEndpoint)!)
            request.HTTPMethod = "POST"
            request.HTTPBody = makeString(parameters, httpMethod: method).dataUsingEncoding(NSUTF8StringEncoding)
        } else {
            postEndpoint = makeUrl(postEndpoint, params: parameters)
            request = NSMutableURLRequest(URL: NSURL(string: postEndpoint)!)
            request.HTTPMethod = "GET"
        }
         print("send url: \(postEndpoint)")
        
        
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
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
    
    private func makeString(params: [String: String], httpMethod: HttpMethod) -> String {
        if params.count == 0 {
            return ""
        }
        
        var result = ""
        for item in params {
            if httpMethod == HttpMethod.GET {
                result += "\(item.0)=\(item.1.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)&"
            } else {
                result += "\(item.0)=\(item.1)&"
            }
        }
        print ("input = \(result)")
        return result
    }
    
    private func makeUrl(url: String, params: [String: String]) -> String {
        if params.count == 0 {
            return url
        }
        
        let queryString = makeString(params, httpMethod: .GET)
        return url + "?" + queryString
    }

}