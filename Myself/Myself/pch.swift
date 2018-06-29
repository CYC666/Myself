//
//  pch.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit


// =============================== 尺寸 ================================
let kScreenWidth : CGFloat = UIScreen.main.bounds.width
let kScreenHeight : CGFloat = UIScreen.main.bounds.height
let Nav_Height : CGFloat = kScreenHeight == 812 ? 88 : 64
let TabBar_Height : CGFloat = kScreenHeight == 812 ? 83 : 49


// =============================== 颜色 ================================
func CRGB(R:CGFloat,_ G:CGFloat,_ B:CGFloat,_ A:CGFloat) -> UIColor {
    return UIColor(red: (R)/255.0, green: (G)/255.0, blue: (B)/255.0, alpha: A)
}
let Public_Color = CRGB(R: 55, 188, 250, 1)
let Label_Color_A = CRGB(R: 51, 51, 51, 1)
let Label_Color_B = CRGB(R: 102, 102, 102, 1)
let Label_Color_C = CRGB(R: 153, 153, 153, 1)
let Label_Color_D = CRGB(R: 197, 197, 197, 1)
let Background_Color = CRGB(R: 235, 235, 235, 1)

// =============================== 字符串 ================================
let ImagePath : String = "/Documents/"
func GetImagePath(_ path : String) -> String {
    return NSHomeDirectory().appending(ImagePath).appending(path)+".png"
}



