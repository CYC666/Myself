//
//  ZoneListImageView.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/29.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

protocol ZoneListImageViewDelegate : NSObjectProtocol {
    
    func ZoneListImageViewSelectIndex(_ index : NSInteger, _ cell : NSInteger)
    
}

class ZoneListImageView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var viewDelegate : ZoneListImageViewDelegate?
    var cellIndex : NSInteger = NSInteger()
    
    
    
    var _dataArray : [String] = [String]()
    var dataArray : [String] {
        
        set {
            _dataArray = newValue
            
            self.reloadData()
        }
        
        get {
            return _dataArray
        }
        
    }
    
    
    
    
    override func awakeFromNib() {
        
        let layout = UICollectionViewFlowLayout.init()
        let size : NSInteger = NSInteger(((kScreenWidth - 70 - 15) - 10) / 3)
        layout.itemSize = CGSize.init(width: size, height: size)
        layout.minimumLineSpacing = (kScreenWidth - CGFloat(size) * 3 - 70 - 15) * 0.5
        layout.minimumInteritemSpacing = (kScreenWidth - CGFloat(size) * 3 - 70 - 15) * 0.5
        self.collectionViewLayout = layout
        self.delegate = self
        self.dataSource = self
        self.register(UINib.init(nibName: "SelectImageCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SelectImageCell")
        
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : SelectImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCell", for: indexPath) as! SelectImageCell
        
        let model : String = dataArray[indexPath.row]
        
        cell.icon.image = UIImage.init(contentsOfFile: GetImagePath(model))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewDelegate?.ZoneListImageViewSelectIndex(indexPath.row, cellIndex)
        
    }
    
    
    

}
