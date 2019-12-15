//
//  OLTheadSafeRun.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/16.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

class OLTheadSafeRun: NSObject {
    static func runOnMainThread(callback: () -> Void) {
        if Thread.isMainThread() {
            callback()
        } else {
            DispatchQueue.main.async {
                callback();
            }
        }
    }
}
