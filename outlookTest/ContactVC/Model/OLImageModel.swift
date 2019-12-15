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
    
    convenience init(imageData: [String: String]) {
        self.init(imageData:imageData, redirectKey:[:]);
    }
    
    convenience init(imageData: [String: String], redirectKey:[String: String]) {
        self.init(imageData:imageData, redirectKey:redirectKey, defaultValue:[:]);
    }
    
    init(imageData: [String: String], redirectKey:[String: String], defaultValue:[String: String]) {
        let newImagePath = redirectKey["imagePath"] ?? "imagePath";
        if let imagePath = imageData[newImagePath] {
            self.imagePath = imagePath;
        } else {
            self.imagePath = defaultValue[newImagePath] ?? "";
        }
        
        let newImageSourceType = redirectKey["imageSourceType"] ?? "imageSourceType";
        if let imageSourceType = imageData[newImageSourceType], let imageSourceTypeIntValue = Int(imageSourceType)  {
            if imageSourceTypeIntValue == 0 {
                self.imageSourceType = .OLImageModelSourceTypeLocal;
            } else if imageSourceTypeIntValue == 1 {
                self.imageSourceType = .OLImageModelSourceTypeURL;
            } else if imageSourceTypeIntValue == 2 {
                self.imageSourceType = .OLImageModelSourceTypeIconFont;
            }
        } else {
            if let imageSourceType = defaultValue[newImageSourceType], let imageSourceTypeIntValue = Int(imageSourceType) {
                self.imageSourceType = OLImageModelSourceType(rawValue: imageSourceTypeIntValue) ?? .OLImageModelSourceTypeUnknown;
            }
        }
    }
}
