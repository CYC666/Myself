//
//  SendController.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

class SendController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listTableView : UITableView = UITableView()
    var bottomView : SendBottomView = SendBottomView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.title = "新建"
        
        
        
        // 表视图
        listTableView = UITableView(frame: CGRect(x: 0, y: Nav_Height, width: kScreenWidth, height: kScreenHeight - Nav_Height - TabBar_Height), style: UITableViewStyle.plain)
        listTableView.tableFooterView = UIView(frame: CGRect.zero)
        listTableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        listTableView.rowHeight = UITableViewAutomaticDimension
//        listTableView.estimatedRowHeight = 250
        listTableView.backgroundColor = UIColor.white
        listTableView.register(UINib(nibName: "SendCell", bundle: Bundle.main), forCellReuseIdentifier: "SendCell")
        listTableView.delegate = self
        listTableView.dataSource = self
        view.addSubview(listTableView)
        
        if #available(iOS 11.0, *) {
            listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        // 底部工具栏
        bottomView = Bundle.main.loadNibNamed("SendBottomView", owner: nil, options: nil)?.first as! SendBottomView
        bottomView.frame = CGRect(x: 0, y: kScreenHeight - TabBar_Height, width: kScreenWidth, height: TabBar_Height)
        bottomView.locationButton.addTarget(self, action: #selector(self.locationButtonAction(_:)), for: UIControlEvents.touchUpInside)
        bottomView.sendButton.addTarget(self, action: #selector(self.sendButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(bottomView)
        
        // 监听键盘弹出和消失
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    // MARK:======================================按钮响应========================================
    
    // MARK:定位
    @objc func locationButtonAction(_ button : UIButton) {
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
    }
    
    // MARK:发送
    @objc func sendButtonAction(_ button : UIButton) {
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
    }
    
    // MARK:======================================代理方法========================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15 + 200 + 50 + (kScreenWidth - 10 - 10 - 5*2) / 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SendCell = tableView.dequeueReusableCell(withIdentifier: "SendCell", for: indexPath) as! SendCell
        
        cell.imageViewsHeight.constant = (kScreenWidth - 10 - 10 - 5*2) / 3
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    // MARK:======================================通知========================================
    
    // MARK:键盘弹出
    @objc func keyBoardShowNotification(_ notifi : NSNotification) {
        
        let userInfo = notifi.userInfo!
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.35) {
            self.bottomView.transform = CGAffineTransform.init(translationX: 0, y: -keyBoardBounds.size.height + (TabBar_Height - 49))
            self.listTableView.frame = CGRect(x: 0, y: Nav_Height, width: kScreenWidth, height: kScreenHeight - Nav_Height - keyBoardBounds.size.height - 49)
        }
        
    }
    
    // MARK:键盘消失
    @objc func keyBoardHideNotification(_ notifi : NSNotification) {
        
        UIView.animate(withDuration: 0.35) {
            self.bottomView.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.listTableView.frame = CGRect(x: 0, y: Nav_Height, width: kScreenWidth, height: kScreenHeight - Nav_Height - TabBar_Height)
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
