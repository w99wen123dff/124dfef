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
            if let imageSourceTypeIntValue = Int(imageSourceType) {
                if imageSourceTypeIntValue == 0 {
                    self.imageSourceType = .OLImageModelSourceTypeLocal;
                } else if imageSourceTypeIntValue == 1 {
                    self.imageSourceType = .OLImageModelSourceTypeURL;
                } else if imageSourceTypeIntValue == 2 {
                    self.imageSourceType = .OLImageModelSourceTypeIconFont;
                }
            }
        }
    }
}
