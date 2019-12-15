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
    override init(frame: CGRect) {
        self.avatarImageView = UIImageView(frame: frame);
        self.avatartBoraderImageView = UIImageView(frame: frame);
        super.init(frame: frame);
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didClickAvatarView));
        self.addGestureRecognizer(tap);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updataWithVO(VO: OLPersonAvatarModelProtocol) {
        
    }
    
    
    @objc func didClickAvatarView() {
        
    }
}
