//
//  UserInfoView.swift
//  Myself
//
//  Created by 曹老师 on 2018/7/10.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

class UserInfoView: UIView {

    
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var headButton: UIButton!
    
    override func awakeFromNib() {
        
        mainView.layer.cornerRadius = (kScreenWidth - 50 * 2) * 0.5
        
        // 初始化用户数据
        if UserDefaults.standard.object(forKey: UserName) != nil {
            nameField.text = UserDefaults.standard.value(forKey: UserName) as? String
        } else {
            UserDefaults.standard.setValue("曹老师_cGTR", forKey: UserName)
        }
        
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
