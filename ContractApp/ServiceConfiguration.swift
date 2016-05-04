//
//  ServiceConfiguration.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/4/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation

class ServiceConfiguration {
    //static let serverName = "localhost"
    static let isUseServiceLocator = true
    static let httpMethod2 = "http"
    static let serviceLocatorStore = ServiceLocatorStore()
    
    
    static let serverName4 = "jjhtest.hengdianworld.com"
    static let port4 = 80
    
    static let serverName3 = "www.jinjunhang.com"
    static let port3 = 3000
    
    static let serverName2 = "oa.lloydind.cn"
    static let port2 = 10443
    
    static let serverName5 = "oa.lloydind.com"
    static let port5 = 10080
    
    static let serverName6 = "localhost"
    static let port6 = 3000
    
    static var serverName: String {
        get {
            if isUseServiceLocator {
                return (serviceLocatorStore.GetServiceLocator()!.serverName)!
            } else {
                return serverName6
            }
        }
    }
    
    static var port: Int {
        get {
            if isUseServiceLocator {
                return Int((serviceLocatorStore.GetServiceLocator()!.port)!)
            } else {
                return port6
            }
        }
    }
    
    static var httpMethod: String {
        get {
            if isUseServiceLocator {
                return (serviceLocatorStore.GetServiceLocator()?.http)!
            } else {
                return "http"
            }
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