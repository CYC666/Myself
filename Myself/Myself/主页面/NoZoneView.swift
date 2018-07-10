//
//  NoZoneView.swift
//  Myself
//
//  Created by 曹老师 on 2018/7/10.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

class NoZoneView: UIView {

    
    @IBOutlet weak var addButton: UIButton!
    
    
    override func awakeFromNib() {
        addButton.layer.cornerRadius = 3
        addButton.layer.borderColor = addButton.titleLabel?.textColor.cgColor
        addButton.layer.borderWidth = 1
    }
    
    
    
    

}
