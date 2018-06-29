//
//  PictureShowCell.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/29.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

class PictureShowCell: UICollectionViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        width.constant = kScreenWidth
        height.constant = kScreenHeight
        
    }

}
