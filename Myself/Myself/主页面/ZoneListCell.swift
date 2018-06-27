//
//  ZoneListCell.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

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
        
        UIView.animate(withDuration: 0.1, animations: {
            
            self.priseImage.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            
        }) { (true) in
            
            UIView.animate(withDuration: 0.1, animations: {
                
                self.priseImage.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                
            }) { (true) in
                
                self.priseImage.image = UIImage.init(named: "点赞2")
                
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
