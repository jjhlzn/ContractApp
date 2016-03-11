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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let startDatePicker = UIDatePicker()
        let endDatePicker = UIDatePicker()
        
        
        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.locale = NSLocale(localeIdentifier: "zh_cn")
        startDateField.delegate = self
        
        endDatePicker.datePickerMode = UIDatePickerMode.Date
        
        endDatePicker.locale = NSLocale(localeIdentifier: "zh_cn")
        endDateField.delegate = self
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "approvalResultSegue" {
            let dest = segue.destinationViewController as! ApprovalListViewController
            let response = sender as! SearchApprovalResponse
            dest.approvals = response.approvals
            dest.hasMore = dest.approvals.count < response.totalNumber
            dest.queryObject = ApprovalQueryObject(keyword: keywordField.text, startDate: nil, endDate: nil, containApproved: approvedSwitch.on, containUnapproved: unapprovedSwitch.on)
        }
    }
    
    @IBAction func searchPressed(sender: UIButton) {
 
        loadingOverlay.showOverlay(self.view)
        approvalService.search(nil, containApproved: true, containUnapproved: true, startDate: nil, endDate: nil, index: 0, pageSize: 10) { response in
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
