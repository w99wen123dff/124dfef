//
//  OLPersonInfoModel.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/14.
//  Copyright © 2019 w99wen. All rights reserved.
//

import Foundation


class OLPersonInfoModel: NSObject, OLPersonInfoProtocol {
    var name: OLPersonFullNameModelProtocol
    
    var avatar: OLPersonAvatarModelProtocol
    
    var title: String = ""
    
    var introduction: String = ""
    
    override init() {
        self.name =
    }
    
    init(name: OLPersonFullNameModelProtocol, avatar: OLPersonAvatarModelProtocol, title: String, introduction: String) {
        self.name = name;
        self.avatar = avatar;
        self.title = title;
        self.introduction = introduction;
    }
}
