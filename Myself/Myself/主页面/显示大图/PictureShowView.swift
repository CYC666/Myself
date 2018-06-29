//
//  PictureShowView.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/29.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

protocol PictureShowViewDelegate : NSObjectProtocol {
    
    func PictureShowViewSelectIndex(_ index : NSInteger)
    
}

class PictureShowView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var viewDelegate : PictureShowViewDelegate?
    
    
    var _dataArray : [String] = [String]()
    var dataArray : [String] {
        
        set {
            _dataArray = newValue
            
            self.delegate = self
            self.dataSource = self
            
            self.reloadData()
        }
        
        get {
            return _dataArray
        }
        
    }
    

    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : PictureShowCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureShowCell", for: indexPath) as! PictureShowCell
        
        let model : String = dataArray[indexPath.row]
        
        cell.icon.image = UIImage.init(contentsOfFile: GetImagePath(model))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewDelegate?.PictureShowViewSelectIndex(indexPath.row)
        
    }
    
    
    
    
}
