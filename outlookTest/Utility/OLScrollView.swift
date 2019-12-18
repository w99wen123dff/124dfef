//
//  OLScrollView.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/16.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit
protocol OLScrollViewDelegate {
    
    func itemViewFor(sourceOLScrollView:OLScrollView, index: Int) -> UIView;
    
    func didSelectItems(sourceOLScrollView:OLScrollView, index: Int);
    
    func scrollViewDidScroll(sourceOLScrollView:OLScrollView)
    
}

class OLCustomHitTestScrollView: UIScrollView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let superview = self.superview {
            let tmp = self.convert(point, to: superview)
            if (superview.frame.contains(tmp)) {
                for index in stride(from: self.subviews.count - 1, through: 0, by: -1) {
                    let subView = self.subviews[index];
                    let tmp2 = self.convert(point, to: subView);
                    if let hittedView = subView.hitTest(tmp2, with: event) {
                        return hittedView;
                    }
                }
                return self;
            }
        }
        return nil;
    }
}

class OLScrollView: UIView, UIScrollViewDelegate {
    private let scrollView = OLCustomHitTestScrollView();
    private let scrollViewContainerView = UIView();
    private var itemViews:[UIView] = []
    var delegate:OLScrollViewDelegate? {
        didSet {
            updateData();
        }
    };
    
    var itemSize:CGSize = CGSize(width: 0, height: 0) {
        didSet{
            updateData();
        }
    };
    
    var avatarInfos: [OLPersonAvatarModelProtocol] = [] {
        didSet {
            updateData();
        }
    };
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        addSubview(scrollViewContainerView);
        scrollViewContainerView.addSubview(scrollView);
        scrollView.isPagingEnabled = true;
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        scrollView.clipsToBounds = false;
        scrollView.delegate = self as UIScrollViewDelegate;
        updateData();
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData() {
        scrollViewContainerView.frame = CGRect(x: 0, y: (frame.size.height - itemSize.height) / 2.0, width: self.OL_width, height: itemSize.height);
        scrollView.frame = CGRect(x: (frame.size.width - itemSize.width) / 2.0, y: (frame.size.height - itemSize.height) / 2.0, width: itemSize.width, height: itemSize.height);
        if delegate != nil {
            scrollView.contentSize = CGSize(width: itemSize.width * CGFloat(avatarInfos.count), height: itemSize.height)
        } else {
            scrollView.contentSize = CGSize(width: 0, height: itemSize.height);
        }
        updateItemViews();
    }
    
    private func updateItemViews() {
        var count = min(itemViews.count, avatarInfos.count);
        for (index, _) in itemViews[0 ..< count].enumerated() {
            if let delegate2 = delegate {
                let itemView = delegate2.itemViewFor(sourceOLScrollView: self, index: index)
                updateItemView(itemView: itemView, index: index);
                itemViews[index] = itemView;
                self.scrollView.addSubview(itemView);
            }
        }
        
        while count < itemViews.count {
            let tmp = itemViews.popLast()!;
            tmp.removeFromSuperview()
            count += 1;
        }
        
        while count < avatarInfos.count {
            if let delegate2 = delegate {
                let itemView = delegate2.itemViewFor(sourceOLScrollView: self, index: count);
                updateItemView(itemView: itemView, index: count);
                scrollView.addSubview(itemView);
                itemViews.append(itemView);
                count += 1;
            }
        }
    }
    
    private func updateItemView(itemView: UIView, index: Int) {
        itemView.isUserInteractionEnabled = true;
        let gestureNameHold = "OLScrollViewItemViewTapGestureRecognizer";
        let marginLeft = (itemSize.width - itemView.OL_width) / 2.0;
        let marginTop = (itemSize.height - itemView.OL_height) / 2.0;
        itemView.OL_left = itemView.OL_left + itemSize.width * CGFloat(index) + marginLeft;
        itemView.OL_top = itemView.OL_top + marginTop;
        var everAdded = false;
        if let gestureRecognizers = itemView.gestureRecognizers {
            for gesture in gestureRecognizers {
                if let gestureName = gesture.name, gestureName == gestureNameHold {
                    everAdded = true;
                    break;
                }
            }
        }
        if !everAdded {
            let tap = UITapGestureRecognizer(target: self, action: #selector(itemViewTaped(sender:)));
            tap.name = gestureNameHold;
            itemView.addGestureRecognizer(tap);
        }
    }
    
    func scrollToIndex(index: Int, animated: Bool) {
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(index) * itemSize.width, y: 0), animated: animated)
    }
    
    func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        self.scrollView.setContentOffset(contentOffset, animated: animated);
    }
    
    func contentOffset() -> CGPoint {
        return self.scrollView.contentOffset;
    }
    
    func itemViewAt(index: Int) -> UIView? {
        if itemViews.count > index && index >= 0 {
            return itemViews[index];
        } else {
            return nil;
        }
    }
    
    func itemInfoAt(index: Int) -> OLPersonAvatarModelProtocol? {
        if avatarInfos.count > index && index >= 0 {
            return avatarInfos[index];
        } else {
            return nil;
        }
    }
    
    @objc func itemViewTaped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let tapLocation = sender.location(in: self.scrollView);
            if itemSize.width > 0 {
                let clickedItemViewIndex: Int = Int(floor(tapLocation.x / itemSize.width));
                if let delegate = self.delegate {
                    delegate.didSelectItems(sourceOLScrollView: self, index: clickedItemViewIndex);
                }
            }
        }
    }
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let delegate = self.delegate {
            delegate.scrollViewDidScroll(sourceOLScrollView: self);
        }
        
        scrollView.isTracking
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
