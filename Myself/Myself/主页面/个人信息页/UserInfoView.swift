//
//  UserInfoView.swift
//  Myself
//
//  Created by 曹老师 on 2018/7/10.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

class UserInfoView: UIView {

    
    
    @IBOutlet weak var right: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var headButton: UIButton!
    
    override func awakeFromNib() {
        
        
        // 初始化用户数据
//        if let value = UserDefaults.value(forKey: UserName) {
//            nameField.text = value as? String
//        } else {
//            UserDefaults.setValue("曹老师_cGTR", forKey: UserName)
//        }
        
        let path : String = GetImagePath(HeadImagePath)
        if let image : UIImage = UIImage.init(contentsOfFile: path) {
            headButton.setImage(image, for: UIControlState.normal)
        } else {
            let tempImage : UIImage = UIImage.init(named: "logo")!
            if Tool.saveImage(image: tempImage, scale: 1, imageName: HeadImagePath) {
                headButton.setImage(tempImage, for: UIControlState.normal)
            } else {
                headButton.setImage(nil, for: UIControlState.normal)
            }
        }
        
        
        
        
        
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
