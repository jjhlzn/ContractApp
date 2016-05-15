//
//  KeyValuePair+CoreDataProperties.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/5/7.
//  Copyright © 2016年 金军航. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension KeyValuePair {

    @NSManaged var key: String?
    @NSManaged var value: String?

}
