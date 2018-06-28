//
//  SendController.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit
import CoreData

class SendController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listTableView : UITableView = UITableView()
    var bottomView : SendBottomView = SendBottomView()
    var tipList : [String] = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.title = "新建"
        self.view.backgroundColor = UIColor.white
        tipList = ["  我是帅哥  ", "  添加标签  "]
        
        
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
    
    // MARK:添加标签
    @objc func addTipsButtonAction(_ button : UIButton) {
        
        if (button.titleLabel?.text?.elementsEqual("  添加标签  "))! {
            // 添加标签
            let alert = UIAlertController(title: "添加标签", message: "请输入标签名", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "确认", style: .default) { (action :UIAlertAction!) in
                let textField = alert.textFields![0] as UITextField
                
                // 不能大于5个字符
                if (textField.text as! String).characters.count <= 5 {
                    
                    // 插入新标签
                    if !(textField.text?.elementsEqual(""))! {
                        let newTip = "  " + textField.text! + "  "
                        self.tipList.insert(newTip, at: self.tipList.count-1)
                        
                        // 如果标签数量大于3个，那么将最后一个删除
                        if self.tipList.count > 3 {
                            self.self.tipList.remove(at: 3)
                        }
                        
                        // 刷新
                        self.listTableView.reloadData()
                    }
                    
                }
                
                
                
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action: UIAlertAction) in
                
            }
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            alert.addTextField { (textField: UITextField) in
                textField.textAlignment = NSTextAlignment.center
            }
            present(alert, animated: true, completion: nil)
            
        } else {
            // 删除标签
            let alert = UIAlertController(title: "是否删除标签?", message: nil, preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "删除", style: .default) { (action :UIAlertAction!) in
                
                self.tipList.remove(at: self.tipList.index(of: (button.titleLabel?.text)!)!)
                
                // 如果最后一个不是 添加标签，那么在最后插入一个 添加标签
                if !(self.tipList.last?.elementsEqual("  添加标签  "))! {
                    self.tipList.insert("  添加标签  ", at: 2)
                }
                
                self.listTableView.reloadData()
                
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action: UIAlertAction) in
                
            }
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK:定位
    @objc func locationButtonAction(_ button : UIButton) {
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        let result : [NSManagedObject] = Tool.searchCoredate("Zone")
        
        let zone : NSManagedObject = result.last!
        let nickName : String = (zone.value(forKey: "nickName") as? String)!
        let headPath : String = (zone.value(forKey: "headPath") as? String)!
        let creatDate : String = (zone.value(forKey: "creatDate") as? String)!
        let content : String = (zone.value(forKey: "content") as? String)!
        let imagesPath : String = (zone.value(forKey: "imagesPath") as? String)!
        let prise : String = (zone.value(forKey: "prise") as? String)!
        let comment : String = (zone.value(forKey: "comment") as? String)!
        let tips = zone.value(forKey: "tips")

        NSLog(nickName)
        NSLog(headPath)
        NSLog(creatDate)
        NSLog(content)
        NSLog(imagesPath)
        NSLog(prise)
        NSLog(comment)

        if tips != nil {
            NSLog(tips as! String)
        }
        
    }
    
    // MARK:发送
    @objc func sendButtonAction(_ button : UIButton) {
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        let cell : SendCell = listTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SendCell
        
        
        // 内容：必须要有文字
        if cell.textView.text.elementsEqual("") {
            return
        }
        
        // 时间戳
        let time : NSInteger = NSInteger(NSDate().timeIntervalSince1970)
        
        // 定义传参
        let nickName : String = "曹老师_cGTR"
        let headPath : String = ""
        let creatDate : String = String.init(format: "%ld", time)
        let content : String = cell.textView.text
        let imagesPath : String = ""
        let prise : String = "0"
        let comment : String = "0"
        let tips : String = ""
        
        let resule : Bool = Tool.insertCoreData("Zone", nickName, headPath, creatDate, content, imagesPath, prise, comment, tips)
        
        if resule {
            NSLog("success")
            self.navigationController?.popViewController(animated: true)
        } else {
            NSLog("error")
        }
        
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
        
        cell.tipList = tipList
        cell.tipButton1.addTarget(self, action: #selector(addTipsButtonAction), for: UIControlEvents.touchUpInside)
        cell.tipButton2.addTarget(self, action: #selector(addTipsButtonAction), for: UIControlEvents.touchUpInside)
        cell.tipButton3.addTarget(self, action: #selector(addTipsButtonAction), for: UIControlEvents.touchUpInside)
        
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
