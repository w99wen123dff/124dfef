//
//  OLFIleLoader.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/15.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

class OLFIleLoader: NSObject {
    static func readLocalData(fileNameStr:String, type:String) -> Any? {
        let path = Bundle.main.path(forResource: fileNameStr, ofType: type);
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return jsonData;
        } catch let error as Error? {
            return error?.localizedDescription;
        }
    }
}
