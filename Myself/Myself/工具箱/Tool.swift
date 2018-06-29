//
//  Tool.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/28.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit
import CoreData

class Tool: NSObject {
    
    
    // MARK:=========================== CoreDate操作 ===========================
    // MARK:查询表内容
    /// - Parameter entityName: 表名
    /// - Returns: 表内容数组
    class func searchCoredate(_ entityName : String) -> [NSManagedObject] {
    
        // 步骤一：获取总代理和托管对象总管
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        
        // 步骤二：建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        // 步骤三：执行请求
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                
                return results
                
            } else {
                return [NSManagedObject]()
            }
            
        } catch  {
            return [NSManagedObject]()
        }
    
    }
    
    // MARK:向表插入数据
    /// - Parameters:
    ///   - entityName: 表名
    ///   - nickName: 昵称
    ///   - headPath: 头像路径
    ///   - creatDate: 创建时间
    ///   - content: 内容
    ///   - imagesPath: 图片路径拼接
    ///   - imagesThumbPath: 缩略图路径拼接
    ///   - prise: 点赞数
    ///   - comment: 评论数
    ///   - tips: 标签
    /// - Returns: 是否插入成功
    class func insertCoreData(_ entityName : String,
                              _ nickName : String,
                              _ headPath : String,
                              _ creatDate : String,
                              _ content : String,
                              _ imagesPath : String,
                              _ imagesThumbPath : String,
                              _ prise : String,
                              _ comment : String,
                              _ tips : String) -> Bool {
        
        // 步骤一：获取总代理和托管对象总管
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        
        // 步骤二：建立一个entity
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObectContext)
        
        let zone = NSManagedObject(entity: entity!, insertInto: managedObectContext)
        
        // 步骤三：保存
        zone.setValue(nickName, forKey: "nickName")
        zone.setValue(headPath, forKey: "headPath")
        zone.setValue(creatDate, forKey: "creatDate")
        zone.setValue(content, forKey: "content")
        zone.setValue(imagesPath, forKey: "imagesPath")
        zone.setValue(imagesThumbPath, forKey: "imagesThumbPath")
        zone.setValue(prise, forKey: "prise")
        zone.setValue(comment, forKey: "comment")
        zone.setValue(tips, forKey: "tips")
        
        // 步骤四：保存entity到托管对象中。如果保存失败，进行处理
        do {
            try managedObectContext.save()
            return true
        } catch  {
            return false
        }
        
        
        
    }
    
    
    
    
    // MARK:=========================== 沙盒操作 ===========================
    // MARK:将图片保存到沙盒
    /// - Parameters:
    ///   - image: 图片
    ///   - scale: 压缩比例
    ///   - imageName: 图片路径
    /// - Returns: 返回是否保存成功
    class func saveImage(image: UIImage, scale: CGFloat, imageName: String) -> Bool{
        
        if let imageData = UIImageJPEGRepresentation(image, scale) as NSData? {
            let fullPath = NSHomeDirectory().appending(ImagePath).appending(imageName)+".png"
            return imageData.write(toFile: fullPath, atomically: true)
        } else {
            return false
        }
    }
    
    
    // MARK:=========================== 有意思操作 ===========================
    // MARK:获取当前时间字符串
    class func getCurrentDateString() -> String{
        
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日_HH:mm:ss"
        
        return dformatter.string(from: now)
        
    }
    
    // MARK:提示
    class func tips(_ ctrl : UIViewController, _ text : String) {
        
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        ctrl.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
