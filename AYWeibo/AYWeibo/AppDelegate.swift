//
//  AppDelegate.swift
//  AYWeibo
//
//  Created by Ayong on 16/5/18.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 1.创建窗口
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        // 2.设置根控制器
//        window?.rootViewController = MainViewController()
        window?.rootViewController = WelcomeViewController()
        
        // 3.显示窗口
        window?.makeKeyAndVisible()
        
        // 设置导航条颜色
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    
        // 设置标签栏背景色和样式颜色
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        return true
    }

}

