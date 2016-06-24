//
//  HomeTableViewCell.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/23.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {
    /// 头像
    @IBOutlet var iconImageView: UIImageView!
    /// 认证图标
    @IBOutlet var verifiedImageView: UIImageView!
    /// 会员图标
    @IBOutlet var vipImageView: UIImageView!
    /// 昵称
    @IBOutlet var nameLabel: UILabel!
    /// 时间
    @IBOutlet var timeLabel: UILabel!
    /// 来源
    @IBOutlet var sourceLabel: UILabel!
    /// 正文
    @IBOutlet var contentLabel: UILabel!
    
    /// 模型数据
    var statuseData: StatuseModel? {
        didSet {
            // 1.设置头像
            if let urlStr = statuseData?.user?.profile_image_url, let url = NSURL(string: urlStr) {
                iconImageView.sd_setImageWithURL(url)
            }
            // 2.设置认证图标
            if let type = statuseData?.user?.verified_type {
                // 2.1 认真图标默认不隐藏
                verifiedImageView.hidden = false
                
                var name = "avatar_vip"
                
                switch type {
                case 0:
                    name = "avatar_vip"
                case 2, 3, 5:
                    name = "avatar_enterprise_vip"
                case 220:
                    name = "avatar_grassroot"
                default:
                    verifiedImageView.hidden = true
                }
                
                verifiedImageView.image = UIImage(named: name)
            }
            
            // 3.设置会员图标
            if let mbrank = statuseData?.user?.mbrank {
                if mbrank >= 1 && mbrank <= 6 {
                    vipImageView.image = UIImage(named: "common_icon_membership_level\(mbrank)")
                    nameLabel.textColor = UIColor.orangeColor()
                } else if mbrank == 0 {
                    vipImageView.image = UIImage(named: "common_icon_membership")
                    nameLabel.textColor = UIColor.orangeColor()
                } else {
                    vipImageView.image = nil
                    nameLabel.textColor = UIColor.blackColor()
                }
            }
            
            // 4.设置昵称
            nameLabel.text = statuseData?.user?.screen_name
            
            // 5.设置时间
            /*
             刚刚：一分钟内
             x分钟前：一小时内
             x小时前：当天
             
             昨天 HH：mm（昨天）
             MM-dd HH：mm（一年内）
             yyyy-MM-dd HH：mm（更早期）
             
             "Fri Jun 24 15:34:06 +0800 2016"
             */

            if var timeStr = statuseData?.created_at {
                
                timeStr = "Fri Jun 22 15:40:06 +0800 2016"
                
                // 1.将服务器返回的时间
                let formatter = NSDateFormatter()
                formatter.dateFormat = "EE MM dd HH:mm:ss Z yyyy"
                // 如果不指定以下区域，真机中可能无法转换
                formatter.locale = NSLocale(localeIdentifier: "en")
                
                let createDate = formatter.dateFromString(timeStr)!
                
                // 2.创建日历
                let calendar = NSCalendar.currentCalendar()
                
                var result = ""
                var formatterStr = "HH:mm"
                
                // 3.对日期进行判断
                if calendar.isDateInToday(createDate) {
                    // 3.1 是今天发布
                    // 比较发布的时间跟当前时间的差值
                    let interval = Int(NSDate().timeIntervalSinceDate(createDate))
                    
                    if interval < 60 {
                        // 时间小于1分钟
                        result = "刚刚"
                        
                    } else if interval < 60 * 60 {
                        // 时间小于一个小时
                        result = "\(interval / 60)分前"
                        
                    } else if interval < 60 * 60 * 24 {
                        // 时间小于一天
                        result = "\(interval / (60 * 60))小时前"
                        
                    }
                    
                } else if calendar.isDateInYesterday(createDate) {
                    // 3.2 昨天发布
                    formatterStr = "昨天" + formatterStr
                    formatter.dateFormat = formatterStr
                    result = formatter.stringFromDate(createDate)
                    
                } else {
                    // 3.3不是今天发布也不是今年发布
                    // 获取两个时间时间间隔
                    let components = calendar.components(.Year, fromDate: createDate, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
                    
                    if components.year >= 1 {
                        // 更早时间
                        formatterStr = "yyyy-MM-dd " + formatterStr
                    
                    } else {
                        // 一年以内
                        formatterStr = "MM-dd " + formatterStr
                        
                    }
                    formatter.dateFormat = formatterStr
                    result = formatter.stringFromDate(createDate)
                    
                }
                timeLabel.text = result
            }
            
            // 6.设置来源
            if let source: NSString = statuseData?.source where source != "" {
                let startIndex = source.rangeOfString(">").location + 1
                let length = source.rangeOfString("<", options: .BackwardsSearch).location - startIndex
                let restStr = source.substringWithRange(NSMakeRange(startIndex, length))
                
                sourceLabel.text = "来自\(restStr)"
            } else {
                sourceLabel.text = ""
            }
            
            // 7.设置正文
            contentLabel.text = statuseData?.text
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubViews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - 内部控制方法
    
    private func setupSubViews() {
        iconImageView.layer.cornerRadius = 25.0
        iconImageView.layer.borderWidth = 1.0
        iconImageView.layer.borderColor = UIColor.grayColor().CGColor
        iconImageView.clipsToBounds = true
    }
    
}
