//
//  FeedFishCell.swift
//  Lento
//
//  Created by corgi on 2022/9/9.
//

import UIKit
import SnapKit

class FeedFishCell: LentoBaseCollectionCell {
 
    var model: FeedModel? {
        didSet {
            dataUpdate()
        }
    }
    
    var imgView: UIImageView!
    var messageLabel: UILabel!
    
    override func commonInitialization() {
        imgView = UIImageView()
        imgView.backgroundColor = UIColor.random(.gentle)
        imgView.layer.cornerRadius = 5
        imgView.layer.masksToBounds = true
        contentView.addSubview(imgView)
        
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.font = .pingFang(12)
        messageLabel.textColor = UIColor.white
        contentView.addSubview(messageLabel)
    }
    
    override func layoutInitialization() {
        imgView.snp.makeConstraints { make in
            make.left.equalTo(kGeneralPaddingleft)
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.top.equalTo(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.left.equalTo(kGeneralPaddingleft)
            make.right.equalTo(-kGeneralPaddingRight)
            make.top.equalTo(imgView.snp.bottom).offset(15)
            make.bottom.lessThanOrEqualTo(-20)
        }
    }
    
    func dataUpdate() {
        imgView.image = nil
        messageLabel.text = model?.content
    }
}

extension FeedFishCell {
    
    static func height(with model: FeedModel) -> CGFloat {
        var height: CGFloat = 100
        height += model.content.boundingHeight(with: kGeneralLayoutMaxWidth, font: .pingFang(12))
        height += (20 + 15 + 20)
        return height
    }
}
