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
    public var OL_left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(value) {
            self.frame = CGRect(x: value, y: self.OL_top, width: self.OL_width, height: self.OL_height)
        }
    }
    
    public var OL_right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set(value) {
            self.frame = CGRect(x: value - self.OL_height, y: self.OL_top, width: self.OL_width, height: self.OL_height)
        }
    }
    
    public var OL_top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(value) {
            self.frame = CGRect(x: self.OL_left, y: value, width: self.OL_width, height: self.OL_height)
        }
    }
    
    public var OL_bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height;
        }
        set(value) {
            self.frame = CGRect(x: self.OL_left, y: value - self.OL_height, width: self.OL_width, height: self.OL_height)
        }
    }
    
    public var OL_width: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.OL_left, y: self.OL_top, width: value, height: self.OL_height)
        }
    }
    
    public var OL_height: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.OL_left, y: self.OL_top, width: self.OL_width, height: value)
        }
    }
}

