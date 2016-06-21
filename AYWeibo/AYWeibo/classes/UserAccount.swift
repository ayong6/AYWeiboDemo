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

    }
    
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_in = aDecoder.decodeIntegerForKey("expires_in") as Int
        self.uid = aDecoder.decodeIntegerForKey("uid") as Int
        self.expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
    }
    
}
