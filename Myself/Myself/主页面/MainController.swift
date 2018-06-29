//
//  MainController.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit
import CoreData

class MainController: UIViewController, UITableViewDataSource, UITableViewDelegate, ZoneListImageViewDelegate {
    
    var listTableView : UITableView = UITableView()
    
    var dataArray = [Any]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.title = "Myself"
        self.view.backgroundColor = UIColor.white
        
        // 导航栏右边按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "白色加号"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.navButtonAcvtion(_:)))
        
        // 表视图
        listTableView = UITableView(frame: CGRect(x: 0, y: Nav_Height, width: kScreenWidth, height: kScreenHeight - Nav_Height - (TabBar_Height - 49)), style: UITableViewStyle.plain)
        listTableView.tableFooterView = UIView(frame: CGRect.zero)
        listTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = 300
        listTableView.backgroundColor = UIColor.white
        listTableView.clipsToBounds = false
        listTableView.register(UINib(nibName: "ZoneListCell", bundle: Bundle.main), forCellReuseIdentifier: "ZoneListCell")
        listTableView.delegate = self
        listTableView.dataSource = self
        view.addSubview(listTableView)
        
        
        if #available(iOS 11.0, *) {
            listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        self.automaticallyAdjustsScrollViewInsets = false;
        
        
        
        dataArray = Tool.searchCoredate("Zone")
        listTableView.reloadData()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        dataArray = Tool.searchCoredate("Zone")
        listTableView.reloadData()
        
    }
    
    // MARK:======================================按钮响应========================================
    // MARK:新建动态
    @objc func navButtonAcvtion(_ button: UIButton) {
        
        self.navigationController?.pushViewController(SendController(), animated: true)
        
    }
    
    // MARK:删除
    @objc func deleteButtonAction(_ button : UIButton) {
        
        let alert = UIAlertController(title: "是否删除?", message: "此操作不可撤销", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "删除", style: .default) { (action :UIAlertAction!) in
            
            let index = button.tag - 200
            
            // 步骤一：获取总代理和托管对象总管
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObectContext = appDelegate.persistentContainer.viewContext
            
            let zoneModel = self.dataArray[index] as! NSManagedObject
            managedObectContext.delete(zoneModel)
            
            do {
                try managedObectContext.save()
                self.dataArray = Tool.searchCoredate("Zone")
                self.listTableView.reloadData()
                
            } catch let error as NSError {
                
                debugPrint("context save error:\(error),description:\(error.userInfo)")
                
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action: UIAlertAction) in
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        

    }
    
    // MARK:点赞
    @objc func priseButtonAction(_ button : UIButton) {
        
        let index = button.tag - 300
        
        // 执行动画
        let cell : ZoneListCell = listTableView.cellForRow(at: NSIndexPath.init(row: index, section: 0) as IndexPath) as! ZoneListCell
        UIView.animate(withDuration: 0.1, animations: {
            
            cell.priseImage.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            
        }) { (true) in
            
            cell.priseImage.image = UIImage.init(named: "点赞2")
            UIView.animate(withDuration: 0.35, animations: {
                
                cell.priseImage.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                
            }) { (true) in
                
                
                // 修改点赞数
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedObectContext = appDelegate.persistentContainer.viewContext
                
                let zoneModel = self.dataArray[index] as! NSManagedObject
                var count = NSInteger(zoneModel.value(forKey: "prise") as! String)
                
                if (count != nil) {
                    count = count! + 1
                } else {
                    count = 1
                }
                
                zoneModel.setValue(String.init(format: "%ld", count!), forKey: "prise")
                
                do {
                    try managedObectContext.save()
                    self.dataArray = Tool.searchCoredate("Zone")
                    self.listTableView.reloadData()
                    
                } catch let error as NSError {
                    
                    debugPrint("context save error:\(error),description:\(error.userInfo)")
                    
                }
                
            }
            
        }
        
        
        
        
        
    }
    
    // MARK:======================================代理方法========================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
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
        
        let model : NSManagedObject = dataArray[indexPath.row] as! NSManagedObject
        
        cell.zoneModel = model
        cell.imagesView.viewDelegate = self
        
        cell.moreButton.tag = 200 + indexPath.row
        cell.moreButton.addTarget(self, action: #selector(deleteButtonAction), for: UIControlEvents.touchUpInside)
        
        cell.priseButton.tag = 300 + indexPath.row
        cell.priseButton.addTarget(self, action: #selector(priseButtonAction), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    // MARK:点击图片
    func ZoneListImageViewSelectIndex(_ index: NSInteger) {
        Tool.tips(self, String.init(format: "%ld", index))
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
