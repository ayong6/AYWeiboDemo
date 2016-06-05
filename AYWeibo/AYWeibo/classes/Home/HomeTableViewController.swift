//
//  HomeTableViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/5/19.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.判断用户是否登录
        if !isLogin {
            // 设置访客视图
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        // 2.导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(self.leftBarButtonItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(self.rightBarButtonItemClick))
    }
    
    // MARK: - 内部控制方法
    
    /// 左侧导航条按钮监听方法
    @objc private func leftBarButtonItemClick() {
        QL2("")
    }
    
    /// 右侧导航条按钮监听方法
    @objc private func rightBarButtonItemClick() {
        QL2("")
    }

    
}
