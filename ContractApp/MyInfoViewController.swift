//
//  MyInfoViewController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/3/3.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class MyInfoViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    
    var loginUser: LoginUser!
    let loginUserStore = LoginUserStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginUser = (loginUserStore.GetLoginUser())!
        userNameLabel.text = loginUser.userName
        nameLabel.text = loginUser.name
        departmentLabel.text = loginUser.department
    }
    

    @IBAction func logoutPressed(sender: UIButton) {
        
        loginUserStore.removeLoginUser()
        performSegueWithIdentifier("logoutSegue", sender: nil)
    }
    
  

}
