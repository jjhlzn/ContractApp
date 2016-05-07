//
//  KeyValuePairStore.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/5/7.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation
import CoreData


class KeyValuePairStore {
    var coreDataStack = CoreDataStack(modelName: "ContractApp")
    
    func save(key: String, value: String) -> Bool {
        
        //首先查询key是否存在
        let oldKeyValuePair: KeyValuePair?
        
        do {
           oldKeyValuePair = try getKeyValuePair(key)  //error happens
        } catch {
            return false
        }
        
        
        if oldKeyValuePair == nil {  //the key is not exist
            let context = coreDataStack.mainQueueContext
            var entity: KeyValuePair!
            context.performBlockAndWait() {
                entity = NSEntityDescription.insertNewObjectForEntityForName("KeyValuePair", inManagedObjectContext: context) as! KeyValuePair
                entity.key = key
                entity.value = value
            }
            
        } else {                     //the key is exist
            oldKeyValuePair?.value = value
        }
        
        do {
            try coreDataStack.saveChanges()
        }
        catch let error {
            print("Core Data save failed: \(error)")
            return false
        }

        return true

    }
    
    private func getKeyValuePair(key: String) throws -> KeyValuePair?  {
        let fetchRequest = NSFetchRequest(entityName: "KeyValuePair")
        fetchRequest.sortDescriptors = nil
        fetchRequest.predicate = nil
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueueUsers: [KeyValuePair]?
        var fetchRequestError: ErrorType?
        mainQueueContext.performBlockAndWait() {
            do {
                mainQueueUsers = try mainQueueContext.executeFetchRequest(fetchRequest) as? [KeyValuePair]
            }
            catch let error {
                fetchRequestError = error
                NSLog("isKeyExist()出现异常")
            }
        }
        
        if fetchRequestError == nil {
            if mainQueueUsers?.count == 0 {
                return nil
            } else {
                return mainQueueUsers![0]
            }
        } else {
            throw fetchRequestError!
        }
    }
    
    
    func get(key: String) -> String? {
        do {
            let pair = try getKeyValuePair(key)
            if pair == nil {
                return nil
            }
            return pair?.value
        } catch {
            return nil
        }
    }
}