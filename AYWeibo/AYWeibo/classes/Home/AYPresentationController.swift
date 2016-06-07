//
//  AYPresentationController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/7.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class AYPresentationController: UIPresentationController {
    
    // 布局modal出来的控制器的尺寸
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        let x = (UIScreen.mainScreen().bounds.width - 200) / 2
        
        presentedView()?.frame = CGRectMake(x, 50, 200, 400)
    }

}
