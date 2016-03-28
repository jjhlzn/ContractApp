//
//  OrderCell.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/27.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var businessPersonLabel: UILabel!
    
    @IBOutlet weak var contractNoLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var guestNameLabel: UILabel!
}

class ApprovalCell : UITableViewCell {
    
    @IBOutlet weak var approvalObjectField: UILabel!
    @IBOutlet weak var keywordField: UILabel!
    @IBOutlet weak var amountField: UILabel!
    @IBOutlet weak var reporterField: UILabel!
    @IBOutlet weak var reportDateField: UILabel!
}

class OrderPurchaseInfoCell : UITableViewCell {
    
    @IBOutlet weak var contractLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var factoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
}

class MyInfoCell : UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}
