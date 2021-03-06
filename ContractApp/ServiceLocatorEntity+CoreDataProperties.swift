//
//  ServiceLocatorEntity+CoreDataProperties.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/4/29.
//  Copyright © 2016年 金军航. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ServiceLocatorEntity {

    @NSManaged var http: String?
    @NSManaged var serverName: String?
    @NSManaged var port: NSNumber?

}
