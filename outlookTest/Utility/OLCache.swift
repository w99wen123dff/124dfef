//
//  OLCache.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/16.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

class OLCache: NSObject {
    static let sharedInstance = OLCache();
    private var kv:[String:UIImage] = [:];
    override init() {
        super.init();
        NotificationCenter.default.addObserver(self, selector: #selector(memowarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    func object(forKey:String) -> UIImage? {
        return kv[forKey];
    }
    
    func setObject(_ imageResult:UIImage, forKey: String) {
        kv[forKey] = imageResult;
    }
    
    func didReceiveMemoryWarning() {
        
    }
    
    @objc func memowarning() {
        kv.removeAll();
    }
}
