//
//  LoginUserStore.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/2.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation
import CoreData

class LoginUserStore {
    var coreDataStack = CoreDataStack(modelName: "ContractApp")
    
    func GetLoginUser() -> LoginUser? {
        let fetchRequest = NSFetchRequest(entityName: "LoginUser")
        fetchRequest.sortDescriptors = nil
        fetchRequest.predicate = nil
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueueUsers: [LoginUser]?
        var fetchRequestError: ErrorType?
        mainQueueContext.performBlockAndWait() {
            do {
                mainQueueUsers = try mainQueueContext.executeFetchRequest(fetchRequest) as? [LoginUser]
            }
            catch let error {
                fetchRequestError = error
                NSLog("GetLoginUser()出现异常")
            }
        }
        
        if fetchRequestError == nil {
            if mainQueueUsers?.count == 0 {
                return nil
            } else {
                return mainQueueUsers![0]
            }
        }
        
        return nil
        
    }
    
    func removeLoginUser() {
        let loginUser = GetLoginUser()
        if loginUser != nil {
            let context = coreDataStack.mainQueueContext
            context.performBlockAndWait() {
                do {
                    context.deleteObject(loginUser!)
                    try self.coreDataStack.saveChanges()
                }
                catch  {
                    NSLog("removeLoginUser throw Error")
                }
            }
        }
    }
    
    func updateApprovalUpdateTime(loginUser: LoginUser, time: NSDate) {
        //存储登录的信息
        let context = coreDataStack.mainQueueContext
        context.performBlockAndWait() {
            loginUser.lastUpdateApproval = time
        }
        
        do {
            try coreDataStack.saveChanges()
        }
        catch let error {
            print("Core Data save failed: \(error)")
        }
    }
}