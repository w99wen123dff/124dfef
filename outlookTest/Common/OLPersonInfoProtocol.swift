//
//  OLPersonInfoProtocol.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/14.
//  Copyright © 2019 w99wen. All rights reserved.
//

import Foundation

protocol OLPersonInfoProtocol {
    var name: OLPersonFullNameModelProtocol { get };
    var avatar: OLPersonAvatarModelProtocol { get };
    var title: String { get };
    var introduction: String { get };
}
