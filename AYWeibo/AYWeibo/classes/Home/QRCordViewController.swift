//
//  QRCordViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/10.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import AVFoundation

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
    private lazy var scanView: AYScanView = AYScanView(frame: AYRectCenterWihtSize(300, 300, controller: self))


    // 输入对象
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: device)
    }()
    
    // 输出对象
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    // 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    // 预览图层
    private lazy var presentLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.配置导航条
        setupNavigationBar()
        
        // 2.添加标签栏
        tabBar.delegate = self
        view.addSubview(tabBar)
        
        // 3.添加扫描视图
        scanView.clipsToBounds = true
        scanView.backgroundColor = UIColor.clearColor()
        view.addSubview(scanView)
        
        // 4.开始扫描二维码
        scanQRCode()
    }
    
    override func viewDidAppear(animated: Bool) {
        scanView.animateWithScan()
    }
    
    // MARK: - 内部方法
    
    private func scanQRCode() {
        // 1.判断输入和输出是否能添加到会话中
        guard
            session.canAddInput(input) &&
            session.canAddOutput(output)
        else {
                return
        }
        
        // 2.添加输入和输出到会话中
        session.addInput(input)
        session.addOutput(output)
        
        // 3.设置输出能够解析的数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        // 4.设置监听输出解析到的数据
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        // 5.添加预览图层
        presentLayer.frame = view.bounds
        view.layer.insertSublayer(presentLayer, atIndex: 0)
        
        // 6.开始扫描
        session.startRunning()
    }
    
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

// MARK: - Delegate
extension QRCordViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        QL2(metadataObjects.last?.stringValue)
    }
}

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