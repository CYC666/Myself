//
//  SendController.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class SendController: UIViewController, UITableViewDataSource, UITableViewDelegate, SelectImageViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    var listTableView : UITableView = UITableView()
    var bottomView : SendBottomView = SendBottomView()
    var tipList : [String] = [String]()
    var imageArray : [SelectImageModel] = [SelectImageModel]()
    var locationManager = CLLocationManager()
    
    
    // MARK:======================================生命========================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        self.title = "新建"
        self.view.backgroundColor = UIColor.white
        tipList = ["  添加标签  "]
        let model : SelectImageModel = SelectImageModel()
        model.image = UIImage.init(named: "添加")!
        model.path = "添加"
        
        imageArray.insert(model, at: 0)
        
        
        // 表视图
        listTableView = UITableView(frame: CGRect(x: 0, y: Nav_Height, width: kScreenWidth, height: kScreenHeight - Nav_Height - TabBar_Height), style: UITableViewStyle.plain)
        listTableView.tableFooterView = UIView(frame: CGRect.zero)
        listTableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
    
    
    // MARK:打开定位
    func loadLocationAction() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    // MARK:定位转城市名
    func locationToCityAction(_ lat : Double, _ lon : Double, _ location : CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            
            if error != nil {
                return
            }
            
            let mark : CLPlacemark = placemark?.last as! CLPlacemark
            
            //省
            let State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
            //区
            let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! NSString
            //城市
            let City: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
            //具体位置
            let Name: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! NSString

            // 更新按钮标题
            self.bottomView.locationButton.setTitle(String.init(format: "%@%@%@%@", State, SubLocality, City, Name), for: UIControlState.normal)
            
            
            //            //国家
            //            let country: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! NSString
            //            //国家编码
            //            let CountryCode: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as! NSString
            //            //街道位置
            //            let FormattedAddressLines: NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
            
        }
        
    }
    
    
    // MARK:======================================按钮响应========================================
    
    // MARK:添加标签
    @objc func addTipsButtonAction(_ button : UIButton) {
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        if (button.titleLabel?.text?.elementsEqual("  添加标签  "))! {
            // 添加标签
            let alert = UIAlertController(title: "添加标签", message: "请输入标签名", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "确认", style: .default) { (action :UIAlertAction!) in
                let textField = alert.textFields![0] as UITextField
                
                // 不能大于5个字符
                let string = textField.text
                let count = string?.count
                if count! <= 5 {
                    
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
        
        if (button.titleLabel?.text?.elementsEqual("你在哪里?"))! {
            // 打开定位
            self.loadLocationAction()
        } else {
            button.setTitle("你在哪里?", for: UIControlState.normal)
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
        
        // 图片
        var images : [String] = [String]()
        var thumbImages : [String] = [String]()
        for (index, item) in imageArray.enumerated() {
            
            // 如果是➕，完事
            if item.path.elementsEqual("添加") {
                break
            }
            
            let timeString = Tool.getCurrentDateString()
            let imagePath = String.init(format: "%@_%ld", timeString, index)
            let imageThumbPath = String.init(format: "thumb_%@_%ld", timeString, index)
            
            // 将图片保存到沙盒，成功则继续，否则返回，清空图片路径
            if Tool.saveImage(image: item.image, scale: 1, imageName: imagePath) {
                images.append(imagePath)
            } else {
                images.removeAll()
                return
            }
            if Tool.saveImage(image: item.image, scale: 0.3, imageName: imageThumbPath) {
                thumbImages.append(imageThumbPath)
            } else {
                thumbImages.removeAll()
                return
            }
            
            
            
        }
        
        
        // 标签
        if (tipList.last?.elementsEqual("  添加标签  "))! {
            tipList.removeLast()
        }
        
        
        
        // 定义传参
        let nickName : String = "曹老师_cGTR"
        let headPath : String = ""
        let creatDate : String = String.init(format: "%ld", time)
        let content : String = cell.textView.text
        let imagesPath : String = images.joined(separator: "|")
        let imagesThumbPath : String = thumbImages.joined(separator: "|")
        let prise : String = "0"
        let comment : String = "0"
        let tips : String = tipList.joined(separator: "|")
        var location : String = ""
        var latitude : String = ""
        var longitude : String = ""
        if (bottomView.locationButton.titleLabel?.text?.elementsEqual("你在哪里?"))! {
            location = ""
            latitude = ""
            longitude = ""
        } else {
            location = (bottomView.locationButton.titleLabel?.text)!
            latitude = String.init(format: "%.6f", (locationManager.location?.coordinate.latitude)!)
            longitude = String.init(format: "%.6f", (locationManager.location?.coordinate.longitude)!)
        }
        
        let resule : Bool = Tool.insertCoreData("Zone", nickName, headPath, creatDate, content, imagesPath, imagesThumbPath, prise, comment, tips, location, latitude, longitude)
        
        if resule {
            self.navigationController?.popViewController(animated: true)
        } else {
            Tool.tips(self, "添加动态失败")
        }
        
    }

    
    
    
    // MARK:======================================代理方法========================================
    // MARK:表视图代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var imagesViewHeight : CGFloat = 0.0
        if imageArray.count > 0 {
            let size : NSInteger = NSInteger(((kScreenWidth - 20) - 5) / 3) + 5
            let line : NSInteger = (imageArray.count - 1) / 3 + 1
            imagesViewHeight = CGFloat(size * line)
        } else {
            imagesViewHeight = 0.0
        }
        
        return 15 + 200 + 50 + imagesViewHeight
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
        
        cell.selectImageView.dataArray = imageArray
        cell.selectImageView.viewDelegate = self
        if imageArray.count > 0 {
            let size : NSInteger = NSInteger(((kScreenWidth - 20) - 5) / 3) + 5
            let line : NSInteger = (imageArray.count - 1) / 3 + 1
            cell.imageViewsHeight.constant = CGFloat(size * line)
        } else {
            cell.imageViewsHeight.constant = 0.0
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK:点击图片
    func SelectImageViewSelectIndex(_ index: NSInteger) {
        
        let model : SelectImageModel = imageArray[index]

        if model.path.elementsEqual("添加") {

            // 选取图片
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: {
                UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
            })


        }
        
    
        
        
        
        
    }
    
    // MARK:选图控制器代理方法
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage]
        
        let model : SelectImageModel = SelectImageModel()
        model.image = image as! UIImage
        
        imageArray.insert(model, at: imageArray.count - 1)
        
        // 如果超过9个元素，那么把最后一个➕去掉
        if imageArray.count > 9 {
            imageArray.removeLast()
        }
        
        listTableView.reloadData()
        
        picker.dismiss(animated: true, completion: {
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        })
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        })
    }
    
    // MARK:定位代理方法
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location : CLLocation = locations.last as! CLLocation
        
        // 判断是否为空
        if location.horizontalAccuracy > 0 {
            let lat : Double = Double(String.init(format: "%.1f", location.coordinate.latitude))!
            let lon : Double = Double(String.init(format: "%.1f", location.coordinate.longitude))!
            
            // 停止定位
            locationManager.stopUpdatingLocation()
            
            // 将定位转成城市名
            self.locationToCityAction(lat, lon, location)
            
        }
        
        
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
