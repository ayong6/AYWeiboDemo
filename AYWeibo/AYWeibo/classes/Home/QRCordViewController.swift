//
//  QRCordViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/10.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class QRCordViewController: UIViewController {
    
    private lazy var tabBar: UITabBar = {
        let x: CGFloat = 0
        let y: CGFloat = self.view.frame.height - 49
        let w: CGFloat = self.view.frame.width
        let h: CGFloat = 49
        let tBar = UITabBar(frame: CGRect(x: x, y: y, width: w, height: h))
        
        tBar.barTintColor = UIColor.blackColor()
        tBar.items = [UITabBarItemExtension(title: "二维码", imageName: "qrcode_tabbar_icon_qrcode", tag: qrCodeItemTag),
                      UITabBarItemExtension(title: "条形码", imageName: "qrcode_tabbar_icon_barcode", tag: barCodeItemTag)]
        tBar.selectedItem = tBar.items?.first

        return tBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.redColor()
        // 1.配置导航条
        setupNavigationBar()
        
        // 2.添加标签栏
        view.addSubview(tabBar)
    }
    
    // MARK: - 内部方法
    
    private func setupNavigationBar() {
        navigationItem.title = "扫一扫"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭",
                                                           style: .Plain,
                                                           target: self,
                                                           action: #selector(self.leftBarBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册",
                                                            style: .Plain,
                                                            target: self,
                                                            action: #selector(self.rightBarBtnClick))
    }
    
    // 导航条按钮监听方法
    @objc private func leftBarBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func rightBarBtnClick() {
        QL2("")
    }
    
}

// 定义扫描码标签栏按钮Tag
private let qrCodeItemTag: Int = 100001
private let barCodeItemTag: Int = 100002