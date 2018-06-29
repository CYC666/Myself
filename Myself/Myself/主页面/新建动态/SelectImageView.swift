//
//  SelectImageView.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/29.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

class SelectImageView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    var _dataArray : [SelectImageModel] = [SelectImageModel]()
    var dataArray : [SelectImageModel] {
        
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
        let size : NSInteger = NSInteger(((kScreenWidth - 20) - 5) / 3)
        layout.itemSize = CGSize.init(width: size, height: size)
        layout.minimumLineSpacing = (kScreenWidth - CGFloat(size) * 3 - 20) * 0.5
        layout.minimumInteritemSpacing = (kScreenWidth - CGFloat(size) * 3 - 20) * 0.5
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
        
        let model : SelectImageModel = dataArray[indexPath.row] 
        
        cell.icon.image = model.image
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
