//
//  MainController.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit
import CoreData

class MainController: UIViewController, UITableViewDataSource, UITableViewDelegate, ZoneListImageViewDelegate, PictureShowViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var listTableView : UITableView = UITableView()
    var pictureView : PictureShowView = PictureShowView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var noDataView : NoZoneView = NoZoneView()
    var infoView : UserInfoView = UserInfoView()

    var dataArray = [Any]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.title = "Myself"
        self.view.backgroundColor = UIColor.white
        
        // 导航栏按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "白色加号"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.navButtonAcvtion(_:)))
        
        // 侧滑显示个人信息视图
        let leftSwipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(infoAction(_:)))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(leftSwipe)
        
        
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
        
        // 个人信息页
        infoView = Bundle.main.loadNibNamed("UserInfoView", owner: nil, options: nil)?.first as! UserInfoView
        infoView.frame = CGRect(x: -kScreenWidth, y: 0, width: kScreenWidth, height: kScreenHeight)
        infoView.backButton.addTarget(self, action: #selector(self.infoBackButtonAction(_:)), for: UIControlEvents.touchUpInside)
        infoView.headButton.addTarget(self, action: #selector(self.headButtonAction(_:)), for: UIControlEvents.touchUpInside)
        infoView.nameField.delegate = self
        UIApplication.shared.keyWindow?.addSubview(infoView)
        infoView.backButton.alpha = 0;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        dataArray = Tool.searchCoredate("Zone", "", "")
        
        listTableView.reloadData()
        
    }
    
    // MARK:======================================按钮响应========================================
    // MARK:个人信息
    @objc func infoAction(_ swipe : UISwipeGestureRecognizer) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.infoView.transform = CGAffineTransform.init(translationX: kScreenWidth, y: 0)
        }) { (true) in
            
            UIView.animate(withDuration: 0.2) {
                self.infoView.backButton.alpha = 1
            }
        }
        
    }
    
    // MARK:退出个人信息
    @objc func infoBackButtonAction(_ button : UIButton) {
        
        UIApplication.shared.keyWindow?.endEditing(true)
        UIView.animate(withDuration: 0.2, animations: {
            self.infoView.backButton.alpha = 0
        }) { (true) in
            
            UIView.animate(withDuration: 0.2, animations: {
                self.infoView.transform = CGAffineTransform.init(translationX: kScreenWidth * 2, y: 0)
            }, completion: { (true) in
                self.infoView.transform = CGAffineTransform.init(translationX: 0, y: 0)
            })
            
        }
    }
    
    // MARK:点击个人信息头像
    @objc func headButtonAction(_ button : UIButton) {
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        // 选取图片
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: {
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        })
        
    }
    
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
                self.dataArray = Tool.searchCoredate("Zone", "", "")
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
    
    // MARK:点击了标签
    @objc func tipButtonAction(_ button : UIButton) {
        
        let ctrl : SearchController = SearchController()
        ctrl.tipWord = "tips"
        ctrl.keyWord = (button.titleLabel?.text)!
        ctrl.title = button.titleLabel?.text
        self.navigationController?.pushViewController(ctrl, animated: true);
        
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
                    self.dataArray = Tool.searchCoredate("Zone", "", "")
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
        
        cell.tipButton1.addTarget(self, action: #selector(tipButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.tipButton2.addTarget(self, action: #selector(tipButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.tipButton3.addTarget(self, action: #selector(tipButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
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
    
    // MARK:个人信息修改昵称
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        if (textField.text?.elementsEqual(""))! {
            textField.text = "曹老师_cGTR"
        }
        
        UserDefaults.standard.setValue(textField.text, forKey: UserName)
        
        return true
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
    
    // MARK:选图控制器代理方法
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage]
        
        // 头像存到沙盒
        Tool.saveImage(image: image as! UIImage, scale: 1, imageName: HeadImagePath)
        infoView.headButton.setImage(image as! UIImage, for: UIControlState.normal)
        
        picker.dismiss(animated: true, completion: {
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        })
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
