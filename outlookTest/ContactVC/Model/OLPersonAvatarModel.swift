//
//  OLPersonAvatarModel.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/15.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

class OLPersonAvatarModel: NSObject, OLPersonAvatarModelProtocol {
    var avatar: OLImageModelProtocol
    var backgroudColor = UIColor.white;
    var boarderColor = UIColor(red: 199 / 256.0, green: 224 / 256.0, blue: 243 / 256.0, alpha: 1);
    var boarderWidth = 4;
    init(avatar: OLImageModelProtocol) {
        self.avatar = avatar;
    }
    
    init(data: [String:String]) {
        self.avatar = OLImageModel(imageData: data, redirectKey: ["imagePath": "avatar_filename"], defaultValue: ["imageSourceType": "0"]);
    }
}
