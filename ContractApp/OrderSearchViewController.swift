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
    
    var queryObject: OrderQueryObject?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
        
        let startDatePicker = UIDatePicker()
        let endDatePicker = UIDatePicker()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if queryObject != nil {
            keyworldField.text = queryObject?.keyword
            startDateField.text = formatter.stringFromDate((queryObject?.startDate)!)
            startDatePicker.date = (queryObject?.startDate)!
            endDateField.text = formatter.stringFromDate((queryObject?.endDate)!)
            endDatePicker.date = (queryObject?.endDate)!
            
        } else {
            let currentDateTime = NSDate()
            let oneMonthAgo = currentDateTime.dateByAddingTimeInterval(-30 * 24 * 60 * 60)
            startDatePicker.date = oneMonthAgo
            
            startDateField.text = formatter.stringFromDate(oneMonthAgo)
            endDateField.text = formatter.stringFromDate(currentDateTime)
        }

        
        startDatePicker.datePickerMode = UIDatePickerMode.Date
     
        startDatePicker.locale = NSLocale(localeIdentifier: "zh_cn")
        startDateField.delegate = self
        
        endDatePicker.datePickerMode = UIDatePickerMode.Date
        
        endDatePicker.locale = NSLocale(localeIdentifier: "zh_cn")
        endDateField.delegate = self


        
        
        startDatePicker.addTarget(self, action: #selector(OrderSearchViewController.datePickerChanged(_:)), forControlEvents: .ValueChanged)
        endDatePicker.addTarget(self, action: #selector(OrderSearchViewController.datePickerChanged1(_:)), forControlEvents: .ValueChanged)
        
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
        let backItem = UIBarButtonItem()
        backItem.title = "查询"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "orderResultSegue" {
            let dest = segue.destinationViewController as! OrderListViewController
            let orderResponse = sender as! SeachOrderResponse
            dest.orders = orderResponse.orders
            dest.hasMore = dest.orders.count < orderResponse.totalNumber
            dest.queryObject = OrderQueryObject(keyword: getKeyword(), startDate: getStartDate(), endDate: getEndDate())
        } else if segue.identifier == "emptyResultSegue" {
            let dest = segue.destinationViewController as! OrderEmptyResultViewController
            dest.queryObject = OrderQueryObject(keyword: getKeyword(), startDate: getStartDate(), endDate: getEndDate())
        }
    }
    
    
    @IBAction func seachPressed(sender: UIButton) {
        
        if !checkForm() {
            return
        }
        
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
                    if orderResponse.totalNumber != 0 {
                        self.performSegueWithIdentifier("orderResultSegue", sender: orderResponse)
                    } else {
                        self.performSegueWithIdentifier("emptyResultSegue", sender: orderResponse)
                    }
                }
            }
            
        }
    }
    
    
    func checkForm() -> Bool {
        if !checkExist(startDateField.text) {
            displayMessage("必须输入开始日期")
            return false
        }
        
        if !checkExist(endDateField.text) {
            displayMessage("必须输入结束日期")
            return false
        }
        
        if !checkDate(startDateField.text!) {
            displayMessage("开始日期格式不正确")
            return false
        }
        
        if !checkDate(endDateField.text!) {
            displayMessage("结束日期格式不正确")
            return false
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.dateFromString(startDateField.text!)
        let endDate = formatter.dateFromString(endDateField.text!)
        if startDate?.compare(endDate!) == NSComparisonResult.OrderedDescending {
            displayMessage("开始日期不能晚于结束日期")
            return false
        }
        
        return true
    }

}
