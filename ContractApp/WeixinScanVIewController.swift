//
//  QQScanViewController.swift
//  swiftScan
//
//  Created by xialibing on 15/12/10.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import swiftScan

class WeixinScanViewController: LBXScanViewController, UIAlertViewDelegate {
    
    
    /**
     @brief  扫码区域上方提示文字
     */
    var topTitle:UILabel?
    
    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash:Bool = false
    
    // MARK: - 底部几个功能：开启闪光灯、相册、我的二维码
    
    //底部显示的功能项
    var bottomItemsView:UIView?
    
    //相册
    var btnFinish:UIButton = UIButton()
    
    //闪光灯
    var btnFlash:UIButton = UIButton()
    
    
    var scanCodes = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置扫码区域参数
        var style = self.scanStyle!
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
        style.photoframeLineW = 2;
        style.photoframeAngleW = 18;
        style.photoframeAngleH = 18;
        style.isNeedShowRetangle = false;
        
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove;
        
        style.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        
        //style.animationImage = UIImage(named: "weixin_line")
        
        self.scanStyle = style
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        drawBottomItems()
    }
    
    
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        super.handleCodeResult(arrayResult)
        for result:LBXScanResult in arrayResult
        {
            print("%@",result.strScanned)
            
            if result.strScanned != nil {
                scanCodes.append(result.strScanned!)
            }
        }
        
    }
    
    
    func drawBottomItems()
    {
        if (bottomItemsView != nil) {
            
            return;
        }
        
        let yMax = CGRectGetMaxY(self.view.frame) - CGRectGetMinY(self.view.frame)
        
        bottomItemsView = UIView(frame:CGRectMake( 0.0, yMax-100,self.view.frame.size.width, 100 ) )
        
        
        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        self.view .addSubview(bottomItemsView!)
        
        
        let size = CGSizeMake(65, 87);
        
        self.btnFlash = UIButton()
        btnFlash.bounds = CGRectMake(0, 0, size.width, size.height)
        btnFlash.center = CGPointMake(CGRectGetWidth(bottomItemsView!.frame)/3, CGRectGetHeight(bottomItemsView!.frame)/2)
        
        btnFlash.setImage(UIImage(named: "flash_off"), forState:UIControlState.Normal)
        btnFlash.setImage(UIImage(named: "flash_on"), forState:UIControlState.Highlighted)
        btnFlash.addTarget(self, action: #selector(WeixinScanViewController.openOrCloseFlash), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.btnFinish = UIButton()
        btnFinish.bounds = btnFlash.bounds
        btnFinish.center = CGPointMake(CGRectGetWidth(bottomItemsView!.frame) * 2/3, CGRectGetHeight(bottomItemsView!.frame)/2)
        btnFinish.setImage(UIImage(named: "finish"), forState: UIControlState.Normal)
        btnFinish.addTarget(self, action: #selector(WeixinScanViewController.finishScanPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        bottomItemsView?.addSubview(btnFinish)
        bottomItemsView?.addSubview(btnFlash)
        
        
        self.view .addSubview(bottomItemsView!)
        
    }
    
    //开关闪光灯
    func openOrCloseFlash()
    {
        scanObj?.changeTorch();
        
        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "flash_on"), forState:UIControlState.Normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "flash_off"), forState:UIControlState.Normal)
        }
    }
    
    func finishScanPressed() {
        print("finishScan called")
        print("scancodes: ")
        for code in scanCodes {
            print(code)
        }
        
        if scanCodes.count == 0 {
            displayMessage("没有扫描到任何条形码")
            return
        }
        
        displayConfirmMessage("确定创建报价单？", delegate: self)
    }
    
    
    func finishScan() {
        //进入到报价单页面
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        finishScan()
    }
    
    
    func displayMessage(message : String) {
        
        let alertView = UIAlertView()
        //alertView.title = "系统提示"
        alertView.message = message
        alertView.addButtonWithTitle("好的")
        alertView.cancelButtonIndex=0
        alertView.delegate=self
        alertView.show()
        
    }
    
    func displayConfirmMessage(message : String, delegate: UIAlertViewDelegate) {
        let alertView = UIAlertView()
        //alertView.title = "系统提示"
        alertView.message = message
        alertView.addButtonWithTitle("确认")
        alertView.addButtonWithTitle("取消")
        alertView.delegate=delegate
        alertView.show()
    }
    
    
}
