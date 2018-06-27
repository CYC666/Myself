//
//  GuideController.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

class GuideController: UIViewController {
    
    @IBOutlet weak var guideImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if kScreenHeight == 480 {
            
            guideImageView.image = UIImage.init(named: "640_960")
            
        } else if kScreenHeight == 568 {
            
            guideImageView.image = UIImage.init(named: "640_1136")
            
        } else if kScreenHeight == 667 {
            
            guideImageView.image = UIImage.init(named: "750_1334")
            
        } else if kScreenHeight == 812 {
            
            guideImageView.image = UIImage.init(named: "1125_2436")
            
        } else {
            
            guideImageView.image = UIImage.init(named: "1242_2208")
            
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
