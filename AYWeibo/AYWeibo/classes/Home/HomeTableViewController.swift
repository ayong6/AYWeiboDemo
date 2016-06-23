//
//  HomeTableViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/5/19.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseViewController {
    
    /// 导航条标题按钮
    private lazy var titleButton: UIButton = {
        let btn = TitleButton()
        let title = UserAccount.loadUserAccount()?.screen_name
        btn.setTitle(title, forState: .Normal)
        btn.addTarget(self, action: #selector(self.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.判断用户是否登录
        if !isLogin {
            // 设置访客视图
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        // 2.初始化导航条按钮
        setupNavigationBar()
        
        // 3.注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.titleChange), name: AYTransitioningManagerPresented, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.titleChange), name: AYTransitioningManagerDismissed, object: nil)
        
        // 4.加载当前登录用户及其所关注（授权）用户的最新微博
        loadStatusesData()

    }
    
    deinit {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 内部控制方法
    
    // 加载当前登录用户及其所关注（授权）用户的最新微博
    private func loadStatusesData() {
        NetWorkTools.shareIntance.loadStatuses { (response) in
            // 1.获取网络数据
            guard let data = response.data else {
                QL2("获取网络数据失败")
                return
            }
            
            // 2.json转字典
            do {
                let dict = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! [String: AnyObject]
                
                // 3.字典转模型
                var statuses = [StatusesModel]()

                guard let arr = dict["statuses"] as? [[String: AnyObject]] else {
                    QL2("提取数据失败")
                    return
                }
                
                for dict in arr {
                    let statuse = StatusesModel(dict: dict)
                    statuses.append(statuse)
                    QL2(statuse.user)
                }
                
            } catch {
                QL2("json解析失败")
            }
        }
    }
    
    // 接收到通知后的实现方法
    @objc private func titleChange() {
        titleButton.selected = !titleButton.selected
    }
    
    private func setupNavigationBar() {
        // 1. 添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention",
                                                           target: self,
                                                           action: #selector(self.leftBarButtonItemClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop",
                                                            target: self,
                                                            action: #selector(self.rightBarButtonItemClick))
        
        // 2. 添加标题按钮
        navigationItem.titleView = titleButton
    }
    
    // 标题按钮监听方法
    @objc private func titleBtnClick(sender: TitleButton){
        QL2("")
        // 1.modal控制器
        // 1.1 获取storyboard
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        
        // 1.2 获取控制器
        guard let presentControl = sb.instantiateInitialViewController() else {
            QL2("获取控制器失败")
            return
        }
        
        // 1.3 modal控制器
        self.presentViewController(presentControl, animated: true, completion: nil)
        
    }
    
    /// 左侧导航条按钮监听方法
    @objc private func leftBarButtonItemClick() {
        QL2("")
    }
    
    /// 右侧导航条按钮监听方法
    @objc private func rightBarButtonItemClick() {
        QL2("")
        let nav = UINavigationController(rootViewController: QRCordViewController())
        nav.navigationBar.barTintColor = UIColor.blackColor()
        nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        presentViewController(nav, animated: true, completion: nil)
    }
    
}


