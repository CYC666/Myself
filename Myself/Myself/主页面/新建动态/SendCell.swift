//
//  SendCell.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

class SendCell: UITableViewCell, UITextViewDelegate {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var imageViewsHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    
    
    @IBOutlet weak var tipButton1: UIButton!
    @IBOutlet weak var tipButton2: UIButton!
    @IBOutlet weak var tipButton3: UIButton!
    
    
    var _tipList : [String] = [String]()
    var tipList : [String] {
        
        set {
            _tipList = newValue
            
            if _tipList.count > 0 {
                tipButton1.setTitle(_tipList[0], for: UIControlState.normal)
                tipButton1.isHidden = false
            } else {
                tipButton1.isHidden = true
            }
            
            if _tipList.count > 1 {
                tipButton2.setTitle(_tipList[1], for: UIControlState.normal)
                tipButton2.isHidden = false
            } else {
                tipButton2.isHidden = true
            }
            
            if _tipList.count > 2 {
                tipButton3.setTitle(_tipList[2], for: UIControlState.normal)
                tipButton3.isHidden = false
            } else {
                tipButton3.isHidden = true
            }
        }
        
        get {
            return _tipList
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        tipButton1.layer.cornerRadius = 5
        tipButton1.layer.borderColor = tipButton1.titleLabel?.textColor.cgColor
        tipButton1.layer.borderWidth = 0.5
        
        tipButton2.layer.cornerRadius = 5
        tipButton2.layer.borderColor = tipButton2.titleLabel?.textColor.cgColor
        tipButton2.layer.borderWidth = 0.5
        
        tipButton3.layer.cornerRadius = 5
        tipButton3.layer.borderColor = tipButton3.titleLabel?.textColor.cgColor
        tipButton3.layer.borderWidth = 0.5
        
        textView.delegate = self
        
    }

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        tipLabel.alpha = 0
        
        
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.elementsEqual("") {
            tipLabel.alpha = 1
        }
        
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.elementsEqual("\n") {
            UIApplication.shared.keyWindow?.endEditing(true)
        }
        
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
