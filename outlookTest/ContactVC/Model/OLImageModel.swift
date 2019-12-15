//
//  OLImageModel.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/14.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

class OLImageModel: NSObject, OLImageModelProtocol{
    var imageSourceType: OLImageModelSourceType = .OLImageModelSourceTypeUnknown
    
    var imagePath: String = ""
    
    init(imageSourceType: OLImageModelSourceType, imagePath: String) {
        self.imageSourceType = imageSourceType;
        self.imagePath = imagePath;
    }
    
    init(imageData: [String: String]) {
        if let imagePath = imageData["imagePath"] {
            self.imagePath = imagePath;
        }
        if let imageSourceType = imageData["imageSourceType"] {
            self.imageSourceType = imageSourceType;
        }
    }
}
