//
//  ApprovalSearchController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/1.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class PriceReportSearchViewController: BaseUIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var keywordField: UITextField!
    
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    

    
    var loginUser: LoginUser!
    let loginUserStore = LoginUserStore()
    var queryObject : PriceReportQueryObject?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
        
        loginUser = loginUserStore.GetLoginUser()!
        
        let startDatePicker = UIDatePicker()
        let endDatePicker = UIDatePicker()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        if queryObject != nil {
            keywordField.text = queryObject?.keyword
            startDateField.text = formatter.stringFromDate((queryObject?.startDate)!)
            startDatePicker.date = (queryObject?.startDate)!
            endDateField.text = formatter.stringFromDate((queryObject?.endDate)!)
            endDatePicker.date = (queryObject?.endDate)!
            
        } else {
            let currentDateTime = NSDate()
            let tomorrow = currentDateTime.dateByAddingTimeInterval(24 * 60 * 60)
            let oneMonthAgo = currentDateTime.dateByAddingTimeInterval(-31 * 24 * 60 * 60)
            
            startDatePicker.date = oneMonthAgo
            startDateField.text = formatter.stringFromDate(oneMonthAgo)
            endDateField.text = formatter.stringFromDate(tomorrow)
            endDatePicker.date = tomorrow
        }
        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.locale = NSLocale(localeIdentifier: "zh_cn")
        
        endDatePicker.datePickerMode = UIDatePickerMode.Date
        endDatePicker.locale = NSLocale(localeIdentifier: "zh_cn")
        startDateField.delegate = self
        endDateField.delegate = self
        
        startDatePicker.addTarget(self, action: #selector(ApprovalSearchController.datePickerChanged(_:)), forControlEvents: .ValueChanged)
        endDatePicker.addTarget(self, action: #selector(ApprovalSearchController.datePickerChanged1(_:)), forControlEvents: .ValueChanged)
        
        startDateField.inputView = startDatePicker
        endDateField.inputView = endDatePicker
        
        setTextFieldHeight(keywordField, height: 45)
        setTextFieldHeight(startDateField, height: 45)
        setTextFieldHeight(endDateField, height: 45)
        
        becomeLineBorder(keywordField)
        becomeLineBorder(startDateField)
        becomeLineBorder(endDateField)
        
        addIconToField(keywordField, imageName: "search")
        addIconToField(startDateField, imageName: "date")
        addIconToField(endDateField, imageName: "date")
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
        return keywordField.text == nil ? "" : keywordField.text!
        
    }
    
    func addIconToField(field: UITextField, imageName: String) {
        let imageView = UIImageView();
        let image = UIImage(named: imageName);
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        view.addSubview(imageView)
        imageView.image = image;
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 25, 25))
        paddingView.addSubview(imageView)
        field.rightView = paddingView;
        field.rightViewMode = UITextFieldViewMode.Always
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "返回"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "priceReportResultSegue" {
            let dest = segue.destinationViewController as! PriceReportListViewController

            dest.queryObject = PriceReportQueryObject(keyword: getKeyword(), startDate: getStartDate(), endDate: getEndDate())
        }
    }
    
    
    @IBAction func searchPressed(sender: UIButton) {
        if !checkForm() {
            return
        }
        
        self.keywordField.resignFirstResponder()
        self.startDateField.resignFirstResponder()
        self.endDateField.resignFirstResponder()
        self.performSegueWithIdentifier("priceReportResultSegue", sender: nil)
        
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
