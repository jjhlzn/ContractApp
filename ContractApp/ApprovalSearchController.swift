//
//  ApprovalSearchController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/1.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class ApprovalSearchController: BaseUIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var keywordField: UITextField!

    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    
    @IBOutlet weak var approvedSwitch: UISwitch!
    @IBOutlet weak var unapprovedSwitch: UISwitch!
    
    
    var approvalService = ApprovalService()
    
    var loginUser: LoginUser!
    let loginUserStore = LoginUserStore()

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loginUser = loginUserStore.GetLoginUser()!
        
        let startDatePicker = UIDatePicker()
        let endDatePicker = UIDatePicker()
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let oneMonthAgo = currentDateTime.dateByAddingTimeInterval(-30 * 24 * 60 * 60)

        
        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.date = oneMonthAgo
        startDatePicker.locale = NSLocale(localeIdentifier: "zh_cn")
        startDateField.delegate = self
        startDateField.text = formatter.stringFromDate(oneMonthAgo)
        
        endDatePicker.datePickerMode = UIDatePickerMode.Date
        
        endDatePicker.locale = NSLocale(localeIdentifier: "zh_cn")
        endDateField.delegate = self
        endDateField.text = formatter.stringFromDate(currentDateTime)
        
        startDatePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: .ValueChanged)
        endDatePicker.addTarget(self, action: "datePickerChanged1:", forControlEvents: .ValueChanged)
        
        startDateField.inputView = startDatePicker
        endDateField.inputView = endDatePicker
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startDateField.text = formatter.stringFromDate(sender.date)
    }
    
    func datePickerChanged1(sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        endDateField.text = formatter.stringFromDate(sender.date)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getStartDate() -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.dateFromString(startDateField.text!)!
    }
    
    func getEndDate() -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.dateFromString(endDateField.text!)!
    }
    
    func getKeyword() -> String {
        return keywordField.text == nil ? "" : keywordField.text!;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "approvalResultSegue" {
            let dest = segue.destinationViewController as! ApprovalListViewController
            let response = sender as! SearchApprovalResponse
            dest.approvals = response.approvals
            dest.hasMore = dest.approvals.count < response.totalNumber
            dest.queryObject = ApprovalQueryObject(keyword: getKeyword(), startDate: getStartDate(), endDate: getEndDate(), containApproved: approvedSwitch.on, containUnapproved: unapprovedSwitch.on)
        }
    }
    
    @IBAction func searchPressed(sender: UIButton) {
 
        loadingOverlay.showOverlay(self.view)
        approvalService.search(loginUser.userName!, keyword: getKeyword(), containApproved: approvedSwitch.on, containUnapproved: unapprovedSwitch.on, startDate: getStartDate(), endDate: getEndDate(), index: 0, pageSize: 10) { response in
            dispatch_async(dispatch_get_main_queue()) {
                self.loadingOverlay.hideOverlayView()
                if response.status != 0 {
                    if response.errorMessage != nil {
                        self.displayMessage(response.errorMessage!)
                    }
                } else {
                    self.performSegueWithIdentifier("approvalResultSegue", sender: response)
                }

            }
        }
        
    }


}
