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
    
    // 扫描视图
    private lazy var scanView: AYScanView = {
        let rect = AYRectCenterWihtSize(300, 300, controller: self)
        let sv = AYScanView(frame: rect)
        
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.redColor()
        // 1.配置导航条
        setupNavigationBar()
        
        // 2.添加标签栏
        tabBar.delegate = self
        view.addSubview(tabBar)
        
        // 3.添加扫描视图
        scanView.clipsToBounds = true
        view.addSubview(scanView)
    }
    
    override func viewDidAppear(animated: Bool) {
        scanView.animateWithScan()
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

// MARK: - UITabBarDelegate
extension QRCordViewController: UITabBarDelegate {
    // 标签栏item按钮监听
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        // 根据当前选中的按钮重新设置二维码容器的高度
        scanView.frame = (item.tag == qrCodeItemTag) ? AYRectCenterWihtSize(300, 300, controller: self) : AYRectCenterWihtSize(300, 150, controller: self)
        
        view.layoutIfNeeded()

        // 移除动画
        scanView.layer.removeAllAnimations()
        
        // 重新开始动画
        scanView.animateWithScan()
    }
}

// MARK: - 定义扫描码标签栏按钮Tag
private let qrCodeItemTag: Int = 100001
private let barCodeItemTag: Int = 100002