//
//  MainController.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

class MainController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listTableView : UITableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.title = "Myself"
        
        // 导航栏右边按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "白色加号"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.navButtonAcvtion(_:)))
        
        // 表视图
        listTableView = UITableView(frame: CGRect(x: 0, y: Nav_Height, width: kScreenWidth, height: kScreenHeight - Nav_Height), style: UITableViewStyle.plain)
        listTableView.tableFooterView = UIView(frame: CGRect.zero)
        listTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = 300
        listTableView.backgroundColor = UIColor.white
        listTableView.register(UINib(nibName: "ZoneListCell", bundle: Bundle.main), forCellReuseIdentifier: "ZoneListCell")
        listTableView.delegate = self
        listTableView.dataSource = self
        view.addSubview(listTableView)
        
        if #available(iOS 11.0, *) {
            listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        

        
    }
    // MARK:======================================按钮响应========================================
    // MARK:新建动态
    @objc func navButtonAcvtion(_ button: UIButton) {
        
        self.navigationController?.pushViewController(SendController(), animated: true)
        
    }
    
    // MARK:======================================代理方法========================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        
        let cell : ZoneListCell = tableView.dequeueReusableCell(withIdentifier: "ZoneListCell", for: indexPath) as! ZoneListCell
        
        cell.imageViewsHeight.constant = kScreenWidth - 70 - 15 - 5 * 2
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
