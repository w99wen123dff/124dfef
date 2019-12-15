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
    
    init(avatar: OLImageModelProtocol) {
        self.avatar = avatar;
    }
}
