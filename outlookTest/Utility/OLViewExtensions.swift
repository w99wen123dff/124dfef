//
//  OLViewExtensions.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/16.
//  Copyright © 2019 w99wen. All rights reserved.
//

import Foundation
import UIKit

// MARK: Frame
extension UIView {
    public var OL_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(value) {
            self.frame = CGRect(x: value, y: self.OL_y, width: self.OL_w, height: self.OL_h)
        }
    }
    
    public var OL_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(value) {
            self.frame = CGRect(x: self.OL_x, y: value, width: self.OL_w, height: self.OL_h)
        }
    }
    
    public var OL_w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.OL_x, y: self.OL_y, width: value, height: self.OL_h)
        }
    }
    
    public var OL_h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.OL_x, y: self.OL_y, width: self.OL_w, height: value)
        }
    }
}

