//
//  OLHeaderComponent.swift
//  outlookTest
//
//  Created by 刘凡 on 2019/12/19.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

protocol OLHeaderComponentProtocl {
    
    func didSelectItems(sourceOLScrollView:OLHeaderComponent, index: Int);
    
    func scrollViewDidScroll(sourceOLScrollView:OLHeaderComponent)
    
}

class OLHeaderComponent: UIView, OLScrollViewDelegate {
    
    private var header:OLScrollView;
    private var lastSelectedIndex: Int = 0
    private var headerHittestView: UIView!;
    var avatarInfos: [OLPersonAvatarModelProtocol] {
        get {
            return self.header.avatarInfos;
        }
        set {
            self.header.avatarInfos = newValue;
        }
    }
    
    var delegate: OLHeaderComponentProtocl?
    
    var contentOffset:CGPoint {
        get {
            return self.header.contentOffset();
        }
        set {
            self.header.setContentOffset(newValue, animated: false);
        }
    }
    
    var itemSize: CGSize {
        get {
            return self.header.itemSize;
        }
        set {
            self.header.itemSize = newValue;
        }
    }
    
    override init(frame: CGRect) {
        self.header = OLScrollView(frame: frame);
        super.init(frame: frame);
        let bound:CGRect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height);
        self.header.frame = bound;
        self.header.delegate = self;
        self.headerHittestView = OLCustomHitTestView(bound) { (hittedView) in
            if hittedView != nil {
                OLEventDispatcher.sharedInstance.dispatchEvent(OLBaseEvent(name: "com.ol.action.obtainFirstResponder", source: "HeaderComponent", data: ["view": self]));
            }
        }
        self.addSubview(headerHittestView);
        headerHittestView.addSubview(self.header);
        self.header.delegate = self as OLScrollViewDelegate;
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        self.header.setContentOffset(contentOffset, animated: animated);
    }
    
    
    //MARK: - OLScrollViewDelegate
    func itemViewFor(sourceOLScrollView:OLScrollView, index: Int) -> UIView {
        let viewFrame = CGRect(x: 0,
                               y: 0,
                               width: OLHeaderAvatarImageViewWidth,
                               height: OLHeaderAvatarImageViewHeight)
        if let view: OLContactAvatarView = sourceOLScrollView.itemViewAt(index: index) as? OLContactAvatarView {
            if avatarInfos.count > index {
                view.updataWithVO(VO: avatarInfos[index]);
                view.frame = viewFrame;
                return view;
            } else {
                return UIView(frame: viewFrame)
            }
        } else {
            let avatarView = OLContactAvatarView(frame: viewFrame);
            avatarView.updataWithVO(VO: avatarInfos[index]);
            return avatarView;
        }
    }
    
    func didSelectItems(sourceOLScrollView:OLScrollView, index: Int) {
        scrollViewSelectAt(sourceOLScrollView, index)
        sourceOLScrollView.scrollToIndex(index: index, animated: true)
        if let delegate = self.delegate {
            delegate.didSelectItems(sourceOLScrollView: self, index: index);
        }
    }
    
    func scrollViewDidScroll(sourceOLScrollView:OLScrollView) {
        let index = Int(floor(sourceOLScrollView.contentOffset().x / OLHeaderItemViewWidth + 0.5)) ;
        if index != lastSelectedIndex {
            scrollViewSelectAt(sourceOLScrollView, index)
        }
        if OLMasterViewTester.sharedInstance.isViewMasterView(self) {
            if let delegate = self.delegate {
                delegate.scrollViewDidScroll(sourceOLScrollView: self);
            }
        }
    }
    
    //MARK: -
    func scrollViewSelectAt(_ sourceOLScrollView: OLScrollView, _ index: Int) {
        if let view: OLContactAvatarView = sourceOLScrollView.itemViewAt(index: index) as? OLContactAvatarView {
            if avatarInfos.count > index && index >= 0 {
                if avatarInfos.count > lastSelectedIndex && lastSelectedIndex >= 0 {
                    avatarInfos[lastSelectedIndex].showBorderColor = false;
                    if let lastSelectedView: OLContactAvatarView = sourceOLScrollView.itemViewAt(index: lastSelectedIndex) as? OLContactAvatarView {
                        lastSelectedView.updataWithVO(VO: avatarInfos[lastSelectedIndex]);
                    }
                }
                avatarInfos[index].showBorderColor = true;
                view.updataWithVO(VO: avatarInfos[index]);
                self.lastSelectedIndex = index;
            }
        }
    }
}
