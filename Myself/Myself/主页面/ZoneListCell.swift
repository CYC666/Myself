//
//  ZoneListCell.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit
import CoreData

class ZoneListCell: UITableViewCell {
    
    // 头像区
    @IBOutlet weak var headButton: UIButton!        // 头部按钮
    @IBOutlet weak var headImage: UIImageView!      // 头像
    @IBOutlet weak var nameLabel: UILabel!          // 名字
    @IBOutlet weak var timeLabel: UILabel!          // 时间
    @IBOutlet weak var followButton: UIButton!      // 关注
    @IBOutlet weak var moreImage: UIImageView!      // 下三角图标
    @IBOutlet weak var moreButton: UIButton!        // 更多
    
    // 文本
    @IBOutlet weak var contentLabel: UILabel!
    
    // 图片区
    @IBOutlet weak var imageViewsHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var buttonE: UIButton!
    @IBOutlet weak var buttonF: UIButton!
    @IBOutlet weak var buttonG: UIButton!
    @IBOutlet weak var buttonH: UIButton!
    @IBOutlet weak var buttonI: UIButton!
    
    // 标签区
    @IBOutlet weak var tipViewsHeight: NSLayoutConstraint!
    @IBOutlet weak var tipButton1: UIButton!
    @IBOutlet weak var tipButton2: UIButton!
    @IBOutlet weak var tipButton3: UIButton!
    
    // 互动区
    @IBOutlet weak var priseImage: UIImageView!
    @IBOutlet weak var priseLabel: UILabel!
    @IBOutlet weak var priseButton: UIButton!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    // 数据
    var _zoneModel : NSManagedObject?
    var zoneModel : NSManagedObject? {
        
        set {
            _zoneModel = newValue
            
            // 昵称
            if let nickName = _zoneModel?.value(forKey: "nickName") {
                nameLabel.text = nickName as? String
            } else {
                nameLabel.text = ""
            }
            
            // 头像
            if let headPath = _zoneModel?.value(forKey: "headPath") {
                headImage.image = UIImage.init(named: headPath as! String)
            } else {
                headImage.image = nil
            }
            
            // 日期
            if let creatDate = _zoneModel?.value(forKey: "creatDate") {
                
                // 时间戳转换成日期
                let timeStamp = NSInteger(creatDate as! String)
                let timeInterval:TimeInterval = TimeInterval(timeStamp!)
                let date = Date(timeIntervalSince1970: timeInterval)
                let dformatter = DateFormatter()
                dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                
                timeLabel.text = (dformatter.string(from: date))
            } else {
                timeLabel.text = ""
            }
            
            // 关注
            followButton.isHidden = true
            
            
            // 内容
            if let content = _zoneModel?.value(forKey: "content") {
                contentLabel.text = content as? String
            } else {
                contentLabel.text = ""
            }
            
            // 图片
            if let imagesPath = _zoneModel?.value(forKey: "imagesPath") {
                
                let images : [String] = (imagesPath as! String).components(separatedBy: "|")
                
                if images.count > 0 {
                    
                    imageViewsHeight.constant = 0
                    
                } else {
                    imageViewsHeight.constant = 0
                }
                
                
            } else {
                imageViewsHeight.constant = 0
            }
            
            // 标签
            if let tips = _zoneModel?.value(forKey: "tips") {
                
                let tipList : [String] = (tips as! String).components(separatedBy: "|")
                
                if tipList.count > 0 && !tipList[0].elementsEqual(""){
                    
                    tipButton1.setTitle("  " + tipList[0] + "  ", for: UIControlState.normal)
                    tipButton1.isHidden = false
                    tipViewsHeight.constant = 40
                } else {
                    tipButton1.isHidden = true
                    tipViewsHeight.constant = 0
                }
                
                if tipList.count > 1  && !tipList[1].elementsEqual("") {
                    
                    tipButton2.setTitle("  " + tipList[1] + "  ", for: UIControlState.normal)
                    tipButton2.isHidden = false
                } else {
                    tipButton2.isHidden = true
                }
                
                if tipList.count > 2  && !tipList[2].elementsEqual("") {
                    
                    tipButton3.setTitle("  " + tipList[2] + "  ", for: UIControlState.normal)
                    tipButton3.isHidden = false
                } else {
                    tipButton3.isHidden = true
                }
                
                
                
                
            } else {
                tipButton1.isHidden = true
                tipButton2.isHidden = true
                tipButton3.isHidden = true
                tipViewsHeight.constant = 0
            }
            
            // 点赞
            if let prise = _zoneModel?.value(forKey: "prise") {
                
                if (prise as! String).elementsEqual("") || (prise as! String).elementsEqual("0") {
                    priseLabel.text = ""
                    priseImage.image = UIImage.init(named: "点赞")
                } else {
                    priseLabel.text = prise as? String
                    priseImage.image = UIImage.init(named: "点赞2")
                }
                
                
            } else {
                priseLabel.text = ""
                priseImage.image = UIImage.init(named: "点赞")
            }
            
            // 评论
            if let comment = _zoneModel?.value(forKey: "comment") {
                
                if (comment as! String).elementsEqual("") || (comment as! String).elementsEqual("0") {
                    commentLabel.text = ""
                    commentImage.image = UIImage.init(named: "评论")
                } else {
                    commentLabel.text = comment as? String
                    commentImage.image = UIImage.init(named: "评论2")
                }
                
                
            } else {
                commentLabel.text = ""
                commentImage.image = UIImage.init(named: "评论")
            }
            
        }
        
        get {
            return _zoneModel
        }
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        headImage.layer.borderColor = Background_Color.cgColor
        headImage.layer.borderWidth = 0.5
        
        tipButton1.layer.cornerRadius = 5
        tipButton1.layer.borderColor = tipButton1.titleLabel?.textColor.cgColor
        tipButton1.layer.borderWidth = 0.5
        
        tipButton2.layer.cornerRadius = 5
        tipButton2.layer.borderColor = tipButton2.titleLabel?.textColor.cgColor
        tipButton2.layer.borderWidth = 0.5
        
        tipButton3.layer.cornerRadius = 5
        tipButton3.layer.borderColor = tipButton3.titleLabel?.textColor.cgColor
        tipButton3.layer.borderWidth = 0.5
        
        priseButton.addTarget(self, action: #selector(self.priseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
    }

    
    // MARK:按钮响应
    @objc func priseButtonAction(_ button : UIButton) {
        
        
        
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
