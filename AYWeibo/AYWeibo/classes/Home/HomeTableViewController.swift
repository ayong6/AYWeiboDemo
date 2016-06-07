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
        
        // 2.初始化导航条按钮
        setupNavigationBar()
    }
    
    // MARK: - 内部控制方法
    
    private func setupNavigationBar() {
        // 1. 添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention",
                                                           target: self,
                                                           action: #selector(self.leftBarButtonItemClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop",
                                                            target: self,
                                                            action: #selector(self.rightBarButtonItemClick))
        
        // 2. 添加标题按钮
        let titlebtn = TitleButton()
        
        titlebtn.setTitle("首页", forState: .Normal)
        titlebtn.addTarget(self, action: #selector(self.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        navigationItem.titleView = titlebtn
    }
    
    // 标题按钮监听方法
    @objc private func titleBtnClick(sender: TitleButton){
        // 1.按钮选中状态
        sender.selected = !sender.selected
        
        // 2.modal控制器
        // 2.1 获取storyboard
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        
        // 2.2 获取控制器
        guard let presentControl = sb.instantiateInitialViewController() else {
            QL2("获取控制器失败")
            return
        }
        
        // 设置代理,自定义尺寸
        presentControl.transitioningDelegate = self
        presentControl.modalPresentationStyle = .Custom
        
        // 2.3 modal控制器
        presentViewController(presentControl, animated: true, completion: nil)
        
    }
    
    /// 左侧导航条按钮监听方法
    @objc private func leftBarButtonItemClick() {
        QL2("")
    }
    
    /// 右侧导航条按钮监听方法
    @objc private func rightBarButtonItemClick() {
        QL2("")
    }
}

// MARK - extention
extension HomeTableViewController: UIViewControllerTransitioningDelegate {
    
    // 自定义modal尺寸
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return AYPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}
