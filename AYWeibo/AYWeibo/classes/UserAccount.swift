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
    
    var access_token: String?
    var expires_in: Int = 0
    var uid: Int = 0
    
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
        
        // 2.尝试从文件中加载
        guard let account = NSKeyedUnarchiver.unarchiveObjectWithFile("userAccount.plist".cachesDir()) as? UserAccount else {
            return UserAccount.account
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

    }
    
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_in = aDecoder.decodeIntegerForKey("expires_in") as Int
        self.uid = aDecoder.decodeIntegerForKey("uid") as Int
    }
    
}
