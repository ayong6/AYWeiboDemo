//
//  OAuthViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/20.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {

    private lazy var customWebView: UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.配置子控制器
        setupSubViews()
        
        // 2.设置约束
        setupConstraints()
        
        // 3.加载请求
        loadRequest()
    }
    
    
    // MARK: - 内部方法
    private func loadRequest() {
        
        // 1.创建URL
        guard let url = NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=1624414075&redirect_uri=http://www.ayong.org") else {
            return
        }
        
        // 2.创建请求
        let request = NSURLRequest(URL: url)
        
        // 3.加载登录界面
        customWebView.loadRequest(request)
    }
    
    private func setupSubViews() {
        customWebView.delegate = self
        view.addSubview(customWebView)
    }
    
    private func setupConstraints() {
        customWebView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: customWebView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: customWebView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: customWebView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: customWebView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
    }
}

// MARK - delegate

extension OAuthViewController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 0.获取URL完整地址
        guard let urlStr = request.URL?.absoluteString else {
            return false
        }
        
        // 1.判断当前是否授权回调页面
        guard urlStr.hasPrefix("https://www.ayong.org/") else {
            QL2("不是授权回调页面")
            return true
        }
        
        // 2.判断授权回调地址中是否包含code=且不包含error_
        let key = "code="
        
        guard urlStr.containsString(key) && !urlStr.containsString("error_") else {
            QL2("授权失败")
            return false
        }
        
        let code = request.URL?.query?.substringFromIndex(key.endIndex)
        
        QL2(code!)
        
        return false
    }
}
