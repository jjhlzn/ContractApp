//
//  ApprovalService.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/4/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation


class ApprovalService : BasicService {
    func search(userId: String, keyword: String, containApproved: Bool, containUnapproved: Bool, startDate: NSDate, endDate: NSDate, index: Int, pageSize: Int, completion: ((searchApprovalResponse: SearchApprovalResponse) -> Void)) -> SearchApprovalResponse {
        let response = SearchApprovalResponse()

        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let parameters = ["userid": userId, "keyword": keyword, "containapproved": "\(containApproved)", "containunapproved": "\(containUnapproved)", "startdate": "\(formatter.stringFromDate(startDate))",
                          "enddate": "\(formatter.stringFromDate(endDate))", "index": "\(index)", "pagesize": "\(pageSize)"]
        
        sendRequest(ServiceConfiguration.SeachApprovalUrl, parameters: parameters, serverResponse: response) { dict -> Void in
            if response.status == 0 {
                var approvals = [Approval]()
                let jsonApprovals = dict["approvals"] as! NSArray
                response.totalNumber = dict["totalNumber"] as! Int
                for jsonApproval in jsonApprovals {
                    let approval = Approval(id: (jsonApproval["id"] as? String)!, approvalObject: jsonApproval["approvalObject"] as? String, keyword: jsonApproval["keyword"] as! String, amount: jsonApproval["amount"] as! NSNumber, reporter: jsonApproval["reporter"] as! String, reportDate: jsonApproval["reportDate"] as! String, status: jsonApproval["status"] as? String, approvalResult: jsonApproval["approvalResult"] as? String, type: jsonApproval["type"] as? String)
                    approvals.append(approval)
                }
                response.approvals = approvals
            }
            completion(searchApprovalResponse: response)
            
        }
        return response
    }
    
   
    
    func audit(userId: String, approvalId: String, result: String, completion: ((response: AuditApprovalResponse) -> Void)) -> AuditApprovalResponse {
        
        let response = AuditApprovalResponse()
        let parameters = ["userid": userId, "result": result, "approvalid": approvalId]
        
        sendRequest(ServiceConfiguration.AuditApprovalUrl, parameters: parameters, serverResponse: response) { dict -> Void in
            if response.status == 0 {
                let json = dict["auditResult"] as! NSDictionary
                response.result = json["result"] as! Bool
                response.message = json["message"] as? String
            }
            completion(response: response)
        }
        return response
    }
    
}
