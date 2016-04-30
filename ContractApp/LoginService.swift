//
//  Service.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation

class LoginService : BasicService {
    func login(userName: String, password: String, completion: ((loginResponse: LoginResponse) -> Void)) -> LoginResponse {
        let response = LoginResponse()
        let paramters = ["x": userName, "y": password]
        sendRequest(ServiceConfiguration.loginUrl, parameters: paramters, serverResponse: response) { dict -> Void in
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
        return ServiceConfiguration.loginUrl
    }
}