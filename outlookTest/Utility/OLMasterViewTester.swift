//
//  OLMasterViewTester.swift
//  outlookTest
//
//  Created by 刘凡 on 2019/12/19.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

class OLMasterViewTester: NSObject, OLEventDispatcherProtocol {
    
    private var masterView: UIView?;
    static let sharedInstance: OLMasterViewTester = {
        let instance = OLMasterViewTester();
        OLEventDispatcher.sharedInstance.addEventListener(eventName: "com.ol.action.obtainFirstResponder", listener: instance);
        return instance;
    }()
    
    func isViewMasterView(_ testView: UIView) -> Bool {
        return self.masterView == testView;
    }
    
    func updateMasterViewWithEvent(_ masterView: UIView) {
        self.masterView = masterView;
    }
    
    //MARK: - OLEventDispatcherProtocol
    func eventFired(event: OLBaseEvent) {
        if event.name == "com.ol.action.obtainFirstResponder" {
            if let view = event.data["view"] {
                if view is UIView {
                    self.masterView = view as? UIView;
                }
            } else {
                self.masterView = nil;
            }
        }
    }
}
