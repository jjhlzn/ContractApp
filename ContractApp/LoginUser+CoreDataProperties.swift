//
//  LoginUser+CoreDataProperties.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/3.
//  Copyright © 2016年 金军航. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LoginUser {

    @NSManaged var department: String?
    @NSManaged var name: String?
    @NSManaged var userName: String?
    @NSManaged var lastUpdateApproval: NSDate?

}
