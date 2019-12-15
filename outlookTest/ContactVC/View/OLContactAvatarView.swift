//
//  OLContactAvatarView.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/15.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

protocol OLContactAvatarViewActionDelegate {
    func didClickAvatarView(avatarView:OLContactAvatarView);
}

class OLContactAvatarView: UIView {
    var avatartVO: OLPersonAvatarModelProtocol?;
    var delegate: OLContactAvatarViewActionDelegate?;
    var avatarImageView: UIImageView;
    var avatartBoraderImageView: UIImageView;
    
    private static var maskImageMap: [UIColor: UIImage] = [:];
    
    override init(frame: CGRect) {
        self.avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height));
        self.avatartBoraderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height));
        super.init(frame: frame);
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didClickAvatarView));
        self.addGestureRecognizer(tap);
        
        self.avatarImageView.backgroundColor = UIColor.white;
        self.avatartBoraderImageView.backgroundColor = UIColor.white;
        self.addSubview(self.avatartBoraderImageView);
        self.addSubview(self.avatarImageView);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updataWithVO(VO: OLPersonAvatarModelProtocol) {
        self.avatartVO = VO;
    }
    
    func updateAvatarImage() -> Void {
        if let avatartVO = self.avatartVO {
            let frame = self.frame;
            let width = frame.size.width - CGFloat(avatartVO.boarderWidth);
            let height = frame.size.height - CGFloat(avatartVO.boarderWidth);
            self.avatarImageView.frame = CGRect(x: CGFloat(avatartVO.boarderWidth), y: CGFloat(avatartVO.boarderWidth), width: width, height: height);
//            self.avatarImageView.image =
        }
    }
    
    func updateAvatartBoraderColor() -> Void {
        if let avatartVO = self.avatartVO, let borderColorImage = OLContactAvatarView.maskImageMap[avatartVO.boarderColor] {
            self.avatartBoraderImageView.image = borderColorImage;
        } else {
            
        }
    }
    
    @objc func didClickAvatarView() {
        
    }
}
