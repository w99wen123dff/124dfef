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
    
    init(name: OLPersonFullNameModelProtocol, avatar: OLPersonAvatarModelProtocol, title: String, introduction: String) {
        self.name = name;
        self.avatar = avatar;
        self.title = title;
        self.introduction = introduction;
    }
    
    init(data: [String:String]) {
        self.name = OLPersonFullNameModel(data: data);
        self.avatar = OLPersonAvatarModel(data: data);
        if let title = data["title"] {
            self.title = title;
        }
        
        if let introduction = data["introduction"] {
            self.introduction = introduction;
        }
    }
}
