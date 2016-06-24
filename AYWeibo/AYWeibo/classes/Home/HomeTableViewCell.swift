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
            if var timeStr = statuseData?.created_at {
                
                // 5.1 将服务器返回的时间格式化为NSDate
                if let createDate = NSDate.createDate(timeStr, dateFormatter: "EE MM dd HH:mm:ss Z yyyy") {
                    // 5.2 生成发布微博时间种类对应的字符串
                    timeLabel.text = createDate.descriptionStringFromDate()
                }

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
