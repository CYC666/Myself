//
//  SelectImageView.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/29.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

protocol SelectImageViewDelegate : NSObjectProtocol {
    
    func SelectImageViewSelectIndex(_ index : NSInteger)
    
}

class SelectImageView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    weak var viewDelegate : SelectImageViewDelegate?
    
    
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
        let size : NSInteger = NSInteger(((kScreenWidth - 20) - 10) / 3)
        layout.itemSize = CGSize.init(width: size, height: size)
        layout.minimumLineSpacing = (kScreenWidth - CGFloat(size) * 3 - 20) * 0.5
        layout.minimumInteritemSpacing = (kScreenWidth - CGFloat(size) * 3 - 20) * 0.5
        self.collectionViewLayout = layout
        self.delegate = self
        self.dataSource = self
        self.register(UINib.init(nibName: "SelectImageCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SelectImageCell")
        
        let longPress : UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(pressGestureAction(_:)))
        self.addGestureRecognizer(longPress)
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewDelegate?.SelectImageViewSelectIndex(indexPath.row)
        
    }
    
    
    
    // MARK:======================================长按拖动========================================
    
    // MARK:长按
    @objc func pressGestureAction(_ press : UILongPressGestureRecognizer) {
        

        if (self.indexPathForItem(at: press.location(in: self)) == nil) {
            return
        }
        
        let indexPath : NSIndexPath = self.indexPathForItem(at: press.location(in: self))! as NSIndexPath
        if indexPath.row == dataArray.count - 1 {
            // 最后一个不操作
            return
        }
        
        let cell = self.cellForItem(at: indexPath as IndexPath)!
        
        switch press.state {
        case UIGestureRecognizerState.began:
            
            // 变大
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
            })
            
            self.bringSubview(toFront: cell)
            self.beginInteractiveMovementForItem(at: indexPath as IndexPath)
            
            
            break
            
        case UIGestureRecognizerState.changed:
            
            // 变大
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
            })
            
            self.updateInteractiveMovementTargetPosition(press.location(in: self))
            
            break
            
        case UIGestureRecognizerState.ended:
            
            
            // 变回原样
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            
            self.endInteractiveMovement()
            
            break
            
        default:
            
            
            // 变回原样
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            self.cancelInteractiveMovement()
        }
        
    }

    // MARK:而移动代理方法
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let model = dataArray[sourceIndexPath.row]
        dataArray.remove(at: sourceIndexPath.row)
        dataArray.insert(model, at: destinationIndexPath.row)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
