//
//  Contract.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/1/5.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class Contract: NSObject {
    var title : String = ""
    var detail : String = ""
    var status : String = ""
    
    init(title : String, detail : String, status : String) {
        self.title = title
        self.detail = detail
        self.status = status
    }
}
