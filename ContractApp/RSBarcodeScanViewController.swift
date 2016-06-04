//
//  RSBarcodeScanViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/6/4.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit
import RSBarcodes_Swift

public class RSBarcodeScanViewController: RSCodeReaderViewController, UIAlertViewDelegate {
    
    var scanCodes = [String]()
    var dispatched: Bool = false
    var isSubmit = false
    override  public func viewDidLoad() {
        super.viewDidLoad()
        focusMarkLayer.setNeedsDisplay()
        self.focusMarkLayer.strokeColor = UIColor.redColor().CGColor
        
        self.cornersLayer.strokeColor = UIColor.yellowColor().CGColor
        
        self.tapHandler = { point in
            print(point)
                        
        }
        
        self.barcodesHandler = { barcodes in
            if !self.dispatched && !self.isSubmit { // triggers for only once
                self.dispatched = true
                for barcode in barcodes {
                    if !self.isSubmit{
                        print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                        self.scanCodes.append(barcode.stringValue)
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.displayConfirmMessage(barcode.stringValue, delegate: self)

                        })
                    }
                }
            }
        }
        

        
        
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.dispatched = false
        self.isSubmit = false
        self.scanCodes = [String]()

    }
    
    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let backButton = UIBarButtonItem()
        backButton.title = "重新扫描"
        navigationItem.backBarButtonItem = backButton
    }
    
    func displayMessage(message : String) {
        
        let alertView = UIAlertView()
        //alertView.title = "系统提示"
        alertView.message = message
        alertView.addButtonWithTitle("好的")
        alertView.cancelButtonIndex=0
        alertView.show()
        
    }
    
    func displayConfirmMessage(message : String, delegate: UIAlertViewDelegate) {
        let alertView = UIAlertView()
        //alertView.title = "系统提示"
        alertView.message = message
        
        alertView.addButtonWithTitle("结束")
        alertView.addButtonWithTitle("继续")
        alertView.delegate=delegate
        alertView.show()
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createReportSegue" {
            let dest = segue.destinationViewController as! CreatePriceReportViewController
            dest.codes = self.scanCodes
        }
    }
    
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.dispatched = false
        switch buttonIndex {
        case 0:
            print("结束")
            finishScan()
            break;
        case 1:
            print("继续")
            
            break;
        default:
            break;
        }
        

    }
    
    @IBAction func finishButtonPressed(sender: AnyObject) {
        finishScan()
    }
    
    func finishScan() {
        if scanCodes.count == 0 {
            displayMessage("没有扫描到任何商品")
            return
        }
        if !isSubmit {
            isSubmit = true
            
        } else {
            return
        }
        performSegueWithIdentifier("createReportSegue", sender: nil)
    }


}


