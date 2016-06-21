//
//  OAuthViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/20.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

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
        guard let url = NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_uri)") else {
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
    
    func webViewDidStartLoad(webView: UIWebView) {
        // 显示提醒
        SVProgressHUD.showInfoWithStatus("正在加载中...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 关闭提醒
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 0.获取URL完整地址
        guard let urlStr = request.URL?.absoluteString else {
            return false
        }
        
        // 1.判断当前是否授权回调页面
        guard urlStr.hasPrefix(WB_Redirect_uri) else {
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
        
        // 3.利用requestToken换取AccessToken
        loadAccessToken(code)
        QL2(code)
        
        return false
    }
    
    private func loadAccessToken(toCode: String?) {
        // 1.准备请求路径
        guard
            let url = NSURL(string: "https://api.weibo.com/oauth2/access_token"),
            let code = toCode
        else {
            return
        }
        
        // 2.准备请求参数
        let parameters = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri":WB_Redirect_uri]
        
        // 3.发送POST请求
         Alamofire.request(.POST, url, parameters: parameters, encoding: .URL, headers: nil).responseJSON { (response) in
            guard let data = response.data else {
                QL2("获取不到数据")
                return
            }
            
            // json转对象
            let dict = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! [String: AnyObject]
            
            // 数据转模型
            let account = UserAccount(dict:dict)
            
            // 归档模型
            account.saveAccount()
            
        }
    }
}
