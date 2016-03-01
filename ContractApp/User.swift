//
//  User.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/1/6.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var userName : String = ""
    var name : String?
    var department : String?
    
    init(userName : String, name : String, department : String) {
        self.userName = userName
        self.name = name
        self.department = department
    }
}
