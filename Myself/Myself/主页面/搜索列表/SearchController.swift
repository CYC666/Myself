//
//  SearchController.swift
//  Myself
//
//  Created by 曹老师 on 2018/7/10.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit
import CoreData

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate, ZoneListImageViewDelegate, PictureShowViewDelegate {
    
    var listTableView : UITableView = UITableView()
    var pictureView : PictureShowView = PictureShowView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var noDataView : NoZoneView = NoZoneView()
    var tipWord : String = String()
    var keyWord : String = String()
    
    
    
    
    var dataArray = [Any]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
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
        
        // 暂无动态的图
        noDataView = Bundle.main.loadNibNamed("NoZoneView", owner: nil, options: nil)?.first as! NoZoneView
        noDataView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        noDataView.addButton.addTarget(self, action: #selector(self.navButtonAcvtion(_:)), for: UIControlEvents.touchUpInside)
        listTableView.addSubview(noDataView)
        noDataView.alpha = 0
        
        
        
        // 搜索
        dataArray = Tool.searchCoredate("Zone", tipWord, keyWord)
        
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
                self.dataArray = Tool.searchCoredate("Zone", self.tipWord, self.keyWord)
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
                    self.dataArray = Tool.searchCoredate("Zone", self.tipWord, self.keyWord)
                    self.listTableView.reloadData()
                    
                } catch let error as NSError {
                    
                    debugPrint("context save error:\(error),description:\(error.userInfo)")
                    
                }
                
            }
            
        }
        
        
    }
    
    // MARK:转发
    func returnButtonAction(_ button : UIButton) {
        
        // 400
    }
    
    // MARK:分享
    @objc func shareButtonAction(_ button : UIButton) {
        
        let index = button.tag - 500
        
        let model : NSManagedObject = dataArray[index] as! NSManagedObject
        
        
        // 如果有照片那就分享照片
        if let imagesPath = model.value(forKey: "imagesPath") {
            
            let images : [String] = (imagesPath as! String).components(separatedBy: "|")
            if images.count > 0 && !((images.first?.elementsEqual(""))!) {
                
                var list : [UIImage]! = [UIImage]()
                for (_ , item) in images.enumerated() {
                    
                    let image = UIImage.init(contentsOfFile: GetImagePath(item))
                    list.append(image!)
                }
                let ctrl : UIActivityViewController = UIActivityViewController.init(activityItems: list, applicationActivities: nil)
                self.present(ctrl, animated: true, completion: nil)
                return
            }
            
        }
        
        // 没有图片就分享文本
        if let content = model.value(forKey: "content") {
            
            let ctrl : UIActivityViewController = UIActivityViewController.init(activityItems: [content], applicationActivities: nil)
            self.present(ctrl, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    // MARK:======================================代理方法========================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        UIView.animate(withDuration: 0.2) {
            if self.dataArray.count == 0 {
                // 显示暂无动态
                self.noDataView.alpha = 1
            } else {
                // 隐藏暂无动态
                self.noDataView.alpha = 0
            }
        }
        
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
        
        cell.imagesView.cellIndex = indexPath.row
        cell.imagesView.viewDelegate = self
        
        cell.moreButton.tag = 200 + indexPath.row
        cell.moreButton.addTarget(self, action: #selector(deleteButtonAction), for: UIControlEvents.touchUpInside)
        
        cell.priseButton.tag = 300 + indexPath.row
        cell.priseButton.addTarget(self, action: #selector(priseButtonAction), for: UIControlEvents.touchUpInside)
        
        cell.shareButton.tag = 500 + indexPath.row
        cell.shareButton.addTarget(self, action: #selector(shareButtonAction), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    // MARK:点击图片
    func ZoneListImageViewSelectIndex(_ index: NSInteger, _ cell : NSInteger) {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: kScreenWidth + 20, height: kScreenHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        pictureView = PictureShowView.init(frame: CGRect.init(x: -10, y: 0, width: kScreenWidth + 20, height: kScreenHeight),
                                           collectionViewLayout: layout)
        pictureView.register(UINib.init(nibName: "PictureShowCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PictureShowCell")
        pictureView.setContentOffset(CGPoint.init(x: (kScreenWidth + 20) * CGFloat(index), y: 0), animated: false)
        pictureView.isPagingEnabled = true
        pictureView.viewDelegate = self
        pictureView.alpha = 0
        
        let model : NSManagedObject = dataArray[cell] as! NSManagedObject
        if let imagesPath = model.value(forKey: "imagesPath") {
            
            let images : [String] = (imagesPath as! String).components(separatedBy: "|")
            if images.count > 0 && !((images.first?.elementsEqual(""))!) {
                
                pictureView.dataArray = images
                UIApplication.shared.keyWindow?.addSubview(pictureView)
                UIView.animate(withDuration: 0.2, animations: {
                    self.pictureView.alpha = 1
                })
            }
        }
        
        
    }
    
    
    // MARK:点击大图图片
    func PictureShowViewSelectIndex(_ index: NSInteger) {
        
        UIView.animate(withDuration: 0.35, animations: {
            self.pictureView.alpha = 0
        }) { (true) in
            self.pictureView.removeFromSuperview()
            self.pictureView = PictureShowView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        }
        
    }

}
