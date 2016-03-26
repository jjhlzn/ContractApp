//
//  OrderSearchViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/29.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class OrderSearchViewController: BaseUIViewController, UITextFieldDelegate {

    @IBOutlet weak var keyworldField: UITextField!
    
    @IBOutlet weak var startDateField: UITextField!
    
    @IBOutlet weak var endDateField: UITextField!
    
    var orderService = OrderService()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        startDateField.text =  formatter.stringFromDate(oneMonthAgo)
        
        
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
        return keyworldField.text == nil ? "" : keyworldField.text!;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "orderResultSegue" {
            let dest = segue.destinationViewController as! OrderListViewController
            let orderResponse = sender as! SeachOrderResponse
            dest.orders = orderResponse.orders
            dest.hasMore = dest.orders.count < orderResponse.totalNumber
            dest.queryObject = OrderQueryObject(keyword: getKeyword(), startDate: getStartDate(), endDate: getEndDate())
        }
    }
    
    
    @IBAction func seachPressed(sender: UIButton) {
        loadingOverlay.showOverlay(self.view)
        orderService.search(getKeyword(), startDate: getStartDate(),
            endDate: getEndDate(), index: 0, pageSize: 10) { orderResponse in
            dispatch_async(dispatch_get_main_queue()) {
                self.loadingOverlay.hideOverlayView()
                if orderResponse.status != 0 {
                    if orderResponse.errorMessage != nil {
                        self.displayMessage(orderResponse.errorMessage!)
                    }
                } else {
                    self.performSegueWithIdentifier("orderResultSegue", sender: orderResponse)
                }
            }
            
        }
    }
}
