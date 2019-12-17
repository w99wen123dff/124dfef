//
//  tmp.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/15.
//  Copyright © 2019 w99wen. All rights reserved.
//

import Foundation
import UIKit
protocol OLPersonAvatarModelProtocol {
    var avatar: OLImageModelProtocol { get };
    var backgroudColor: UIColor { get };
    var boarderColor: UIColor { get };
    var boarderWidth: Float { get };
    var showBorderColor: Bool { get set };
}
