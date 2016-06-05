//
//  ButtonExtension.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/5.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(imageName: String, backgroundImageName: String) {
        self.init()
        
        // 1.设置前景图片
        self.setImage(UIImage(named: imageName), forState: .Normal)
        self.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        
        // 2.设置背景图片
        self.setBackgroundImage(UIImage(named: backgroundImageName), forState: .Normal)
        self.setBackgroundImage(UIImage(named: backgroundImageName + "_highlighted"), forState: .Highlighted)
        
        self.sizeToFit()
    }
}

