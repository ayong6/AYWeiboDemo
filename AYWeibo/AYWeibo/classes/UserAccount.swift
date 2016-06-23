//
//  UserAccount.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/21.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    /// 定义属性保存授权模型
    static var account: UserAccount?
    /// 令牌
    var access_token: String?
    /// 过期时间，从授权那一刻开始，多少秒之后过期
    var expires_in: Int = 0 {
        didSet {
            expires_Date = NSDate(timeIntervalSinceNow: NSTimeInterval(expires_in))
        }
    }
    /// 用户ID
    var uid: Int = 0
    /// 真正过期时间
    var expires_Date: NSDate?
    /// 用户昵称
    var screen_name: String?
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.setValuesForKeysWithDictionary(dict)
    }
    
    // 当KVC发现没有对应的KEY时就会调用
    // 重写这个方法会保证 setValuesForKeysWithDictionary 继续遍历后续的 key，避免程序会直接崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // 同过重写这个属性，可快速查看模型的键值对
    override var description: String {
        let propertys = ["access_token", "expires_in", "uid"]
        let dict = dictionaryWithValuesForKeys(propertys)
        
        return "\(dict)"
    }
    
    // MARK: - 外部控制方法
    
    /// 归档存储
    func saveAccount() -> Bool {
       
        return NSKeyedArchiver.archiveRootObject(self, toFile: "userAccount.plist".cachesDir())
    }
    
    /// 获取用户信息
    /// 调用此方法之前，确保已经授权完成并对access_token令牌数据进行转模型
    func loadUserInfo(completion:(account: UserAccount) -> ()) {
        // 断言
        // 断定access_token一定不等于nil的，如果运行的时候access_token等于nil，程序就会崩溃并且报错
        assert(access_token != nil, "使用该方法必须先授权")
        
        // 1.准备请求参数
        let parameters = ["access_token": access_token!, "uid": uid]
        
        // 2.发送请求
        NetWorkTools.shareIntance.loadUserInfo(parameters as! [String : AnyObject]) { (response) in
            guard let data = response.data else {
                QL2("获取不到数据")
                return
            }
            
            do {
                let dict = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [String: AnyObject]
                
                // 1.取出用户信息
                self.screen_name = dict["screen_name"] as? String
                self.avatar_large = dict["avatar_large"] as? String
                
                // 2.保存授权信息
                completion(account: self)
                
            } catch {
                QL2("json转字典失败")
            }
        }
    }
    
    /// 解档读取
    class func loadUserAccount() -> UserAccount? {
        // 1.判断是否已经加载过了
        if UserAccount.account != nil {
            QL2("已经加载过")
            return UserAccount.account
        }
        
        QL2("userAccount.plist".cachesDir())
        
        // 2.尝试从文件中加载
        guard let account = NSKeyedUnarchiver.unarchiveObjectWithFile("userAccount.plist".cachesDir()) as? UserAccount else {
            QL2("没有缓存授权文件")
            return nil
        }
        
        // 3.校验是否过期
        guard let date = account.expires_Date where date.compare(NSDate()) != .OrderedAscending else {
            QL2("令牌过期了")
            return nil
        }
    
        UserAccount.account = account
        
        return UserAccount.account
    }
    
    /// 判断用户是否登录
    class func isLogin() -> Bool {
        return UserAccount.loadUserAccount() != nil
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeInteger(expires_in, forKey: "expires_in")
        aCoder.encodeInteger(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_in = aDecoder.decodeIntegerForKey("expires_in") as Int
        self.uid = aDecoder.decodeIntegerForKey("uid") as Int
        self.expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        self.avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        self.screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
    
}
