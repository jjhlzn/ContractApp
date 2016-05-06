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
    static let isUseConfig = true
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
            if isUseConfig {
                return (serviceLocatorStore.GetServiceLocator()!.serverName)!
            } else {
                return serverName6
            }
        }
    }
    
    static var port: Int {
        get {
            if isUseConfig {
                return Int((serviceLocatorStore.GetServiceLocator()!.port)!)
            } else {
                return port6
            }
        }
    }
    
    static var httpMethod: String {
        get {
            if isUseConfig {
                return (serviceLocatorStore.GetServiceLocator()?.http)!
            } else {
                return "http"
            }
        }
    }
    
    
    static var SeachOrderUrl : String {
        get {
            return "\(httpMethod)://\(serverName):\(port)/order/search.json"
        }
    }
    
    static var GetOrderPurcaseInfoUrl : String {
        get {
            return "\(httpMethod)://\(serverName):\(port)/order/getPurchaseInfo.json"
        }
    }
    
    static var GetBasicInfoUrl : String {
        get {
            return "\(httpMethod)://\(serverName):\(port)/order/getBasicInfo.json"
        }
    }
    
    static var GetOrderChuyunInfoUrl : String {
        get {
            return "\(httpMethod)://\(serverName):\(port)/order/getChuyunInfo.json"
        }
    }
    
    static var GetOrderFukuangInfoUrl : String {
        get {
            return "\(httpMethod)://\(serverName):\(port)/order/getFukuangInfo.json"
        }
    }
    
    static var GetOrderShouhuiInfoUrl : String {
        get {
            return "\(httpMethod)://\(serverName):\(port)/order/getShouhuiInfo.json"
        }
    }
    
    static var SeachApprovalUrl : String {
        get {
            return "\(httpMethod)://\(serverName):\(port)/approval/search.json"
        }
    }
    
    static var AuditApprovalUrl : String {
        get {
            return "\(httpMethod)://\(serverName):\(port)/approval/audit.json"
        }
    }
    
    static var loginUrl : String {
        get {
            return "\(httpMethod)://\(serverName):\(port)/login/login.json"
        }
    }
}