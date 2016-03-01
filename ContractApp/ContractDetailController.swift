//
//  ContractDetailController.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/1/5.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit

class ContractDetailController: ViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    var contract : Contract?
    
    override func viewDidLoad() {
        if contract != nil {
            titleLabel.text = contract?.title
            detailLabel.text = contract?.detail
        }
    }
    
    @IBAction func passPressed(sender: UIButton) {
        
    }
    
    
    
    @IBAction func unpassPressed(sender: UIButton) {
    }
    
    
    
}
