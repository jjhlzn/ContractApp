//
//  LocatorService.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/4/29.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation

class LocatorService : BasicService {
    
    func getServiceLocator(completion: ((response: GetServiceLocatorResponse) -> Void)) -> GetServiceLocatorResponse {
        let response = GetServiceLocatorResponse()
        let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let appBundle = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
        let params = ["app": "huayuan_contract",
                      "version": "\(version)-\(appBundle)"]
        
        print("version = \(version)")
        print("appBundle = \(appBundle)")
        print(params)
        sendRequest("http://serviceLocator.hengdianworld.com:9000/servicelocator", parameters: params, serverResponse: response) { dict -> Void in
            if response.status == 0 {
                let resultJson = dict["result"] as! NSDictionary
                let serviceLocator = ServiceLocator()
                serviceLocator.http = resultJson["http"] as! String
                serviceLocator.serverName = resultJson["serverName"] as! String
                serviceLocator.port = resultJson["port"] as! Int
                response.result = serviceLocator
            }
            completion(response: response)
        }
        return response
    }
}