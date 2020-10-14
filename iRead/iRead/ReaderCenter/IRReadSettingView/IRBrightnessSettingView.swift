//
//  IRBrightnessSettingView.swift
//  iRead
//
//  Created by zzyong on 2020/10/14.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRBrightnessSettingView: UIView {

    static let bottomSapcing: CGFloat = 5
    static let viewHeight: CGFloat = 45
    static let totalHeight = bottomSapcing + viewHeight

    var brightnessSlider = UISlider()
    var hightIcon = UIImageView()
    var lowIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    func setupSubviews() {
        
        let margin: CGFloat = 10
        
        lowIcon.image = UIImage.init(named: "brightness_low")
        self.addSubview(lowIcon)
        lowIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(margin)
            make.height.width.equalTo(18)
            make.centerY.equalTo(self)
        }
        
        hightIcon.image = UIImage.init(named: "brightness_hight")
        self.addSubview(hightIcon)
        hightIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-margin)
            make.height.width.equalTo(27)
            make.centerY.equalTo(self)
        }
        
        self.addSubview(brightnessSlider)
        brightnessSlider.snp.makeConstraints { (make) in
            make.right.equalTo(hightIcon.snp.left).offset(-margin)
            make.left.equalTo(lowIcon.snp.right).offset(margin)
            make.centerY.equalTo(self)
        }
    }
}
