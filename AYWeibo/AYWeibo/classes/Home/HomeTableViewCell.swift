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
            
            // 3.设置会员图标
            
            // 4.设置昵称
            nameLabel.text = statuseData?.user?.screen_name
            
            // 5.设置时间
            timeLabel.text = statuseData?.created_at
            
            // 6.设置来源
            sourceLabel.text = statuseData?.source
            
            // 7.设置正文
            contentLabel.text = statuseData?.text
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
