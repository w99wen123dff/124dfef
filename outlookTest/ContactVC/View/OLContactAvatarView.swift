//
//  OLContactAvatarView.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/15.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

//protocol OLContactAvatarViewActionDelegate {
//    func didClickAvatarView(avatarView:OLContactAvatarView);
//}

class OLContactAvatarView: UIView {
    private var avatartVO: OLPersonAvatarModelProtocol?;
    //    var delegate: OLContactAvatarViewActionDelegate?;
    var avatarImageView: UIImageView;
    var avatarBoarderImageView: UIImageView;
    private static let imageDecodeQueue = DispatchQueue(label: "com.ol.contact.OLContactAvatarView.imageDecodeQueue");
    var operation: OLImageOperation?;
    
    override init(frame: CGRect) {
        self.avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height));
        self.avatarBoarderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height));
        super.init(frame: frame);
        self.avatarBoarderImageView.isHidden = true;
        self.addSubview(avatarBoarderImageView);
        self.addSubview(self.avatarImageView);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updataWithVO(VO: OLPersonAvatarModelProtocol) {
        self.avatartVO = VO;
        updateAvatarImage();
        updateBoarderImageView();
    }
    
    func updateAvatarImage() -> Void {
        if let avatartVO = self.avatartVO {
            self.avatarImageView.frame = CGRect(x: CGFloat(avatartVO.boarderWidth),
                                                y: CGFloat(avatartVO.boarderWidth),
                                                width: self.OL_width - CGFloat(avatartVO.boarderWidth * 2),
                                                height: self.OL_height - CGFloat(avatartVO.boarderWidth * 2));
            let frame = self.avatarImageView.frame;
            let width = self.avatarImageView.OL_width;
            let height = self.avatarImageView.OL_height;
            if let oldOperation = self.operation {
                oldOperation.invalidate();
                self.operation = nil;
            }
            let info = OLImageWithBoraderModel(imageSource: avatartVO.avatar,
                                               borderColor: avatartVO.boarderColor,
                                               borderWidth: 0,
                                               radius: min(width, height) / 2.0,
                                               size: frame.size);
            if let image = OLCache.sharedInstance.object(forKey: info.description()) {
                self.avatarImageView.image = image;
            } else {
                OLContactAvatarView.imageDecodeQueue.async {
                    self.operation = OLImageUtility.loadImage(imageInfo: info) { (image, error, imageModel) in
                        if let imageResult = image, error == nil {
                            self.avatarImageView.image = imageResult;
                            OLCache.sharedInstance.setObject(imageResult, forKey: info.description());
                        }
                    };
                }
            }
        }
    }
    
    func boraderImageCacheKey(VO: OLPersonAvatarModelProtocol) -> String {
        return "__boraderImageCacheKey__\(VO.boarderWidth)|\(VO.boarderColor)__"
    }
    
    func updateBoarderImageView() -> Void {
        if let avatartVO = self.avatartVO {
            self.avatarBoarderImageView.isHidden = !avatartVO.showBorderColor;
            if avatartVO.showBorderColor {
                if let boraderImage = OLCache.sharedInstance.object(forKey: boraderImageCacheKey(VO: avatartVO)) {
                    self.avatarBoarderImageView.image = boraderImage;
                } else {
                    let boraderImage = UIImage.image(size: self.avatarBoarderImageView.frame.size, radius: self.avatarBoarderImageView.OL_width / 2.0, color: avatartVO.boarderColor);
                    OLCache.sharedInstance.setObject(boraderImage, forKey: boraderImageCacheKey(VO: avatartVO));
                    self.avatarBoarderImageView.image = boraderImage;
                }
            }
        } else {
            self.avatarBoarderImageView.isHidden = true;
        }
    }
}
