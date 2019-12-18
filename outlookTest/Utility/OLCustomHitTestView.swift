//
//  OLCustomHitTestView.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/19.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

class OLCustomHitTestView: UIView {
    var callback:(_ hittedView: UIView?) -> Void;
    
    
    init(_ frame:CGRect, callback:@escaping (_ hittedView: UIView?) -> Void) {
        self.callback = callback;
        super.init(frame: frame);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hittedView = super.hitTest(point, with: event);
        self.callback(hittedView);
        return hittedView;
    }
}
