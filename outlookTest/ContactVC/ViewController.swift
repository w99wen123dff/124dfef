//
//  TableViewController.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/14.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

let OLHeaderItemViewWidth: CGFloat = 88;
let OLHeaderItemViewHeight: CGFloat = 88;

let OLHeaderAvatarImageViewWidth: CGFloat = 64 + 4 * 2;
let OLHeaderAvatarImageViewHeight: CGFloat = 64 + 4 * 2;

class ViewController: UIViewController, OLContactViewModelDataSourceProtocol, OLScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    private var header:OLScrollView! = nil;
    private var avatarInfos:[OLPersonAvatarModelProtocol] = [];
    private var personInfos:[OLPersonInfoProtocol] = [];
    private var lastSelectedIndex: Int = 0
    private let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0), style: UITableView.Style.plain);
    private var masterView: UIView?;
    private var headerHittestView: UIView!;
    private var tableHittestView: UIView!;
    static let reuseIdentifier = "reuseIdentifier";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.automaticallyAdjustsScrollViewInsets = false;
        
        self.title = "Contact";
        var top:CGFloat = 0;
        if let navigationController = self.navigationController {
            top = navigationController.navigationBar.frame.origin.y + navigationController.navigationBar.frame.size.height;
        }
        top += UIApplication.shared.statusBarFrame.size.height;
        
        self.header = OLScrollView(frame: CGRect(x: 0, y: top, width: self.view.OL_width, height: OLHeaderItemViewHeight));
        self.header.delegate = self as OLScrollViewDelegate;
        self.header.itemSize = CGSize(width: OLHeaderItemViewWidth, height: OLHeaderItemViewHeight);
        headerHittestView = OLCustomHitTestView(self.header.frame) { (hittedView) in
            if hittedView != nil {
                self.masterView = self.header;
            }
        }
        self.header.frame = headerHittestView.bounds;
        headerHittestView.addSubview(self.header);
        self.view.addSubview(headerHittestView);
        
        
        self.tableView.register(OLPersonInfoTableViewCell.self, forCellReuseIdentifier: ViewController.reuseIdentifier);
        self.tableView.OL_top = headerHittestView.OL_bottom
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = .none;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        self.tableView.delegate = self;
        self.tableView.isPagingEnabled = true;
        self.tableView.dataSource = self;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.OL_height = self.view.OL_height - headerHittestView.OL_bottom;
        tableHittestView = OLCustomHitTestView(self.tableView.frame) { (hittedView) in
            if hittedView != nil {
                self.masterView = self.tableView;
            }
        }
        self.tableView.frame = tableHittestView.bounds;
        tableHittestView.addSubview(self.tableView)
        self.view.addSubview(tableHittestView);
        
        
        OLContactViewModel.sharedInstance().delegate = self;
    }
    
    // MARK: - OLContactViewModelDataSourceProtocol
    func allDataChanged(datas: [OLPersonInfoProtocol]) {
        print(datas.count);
        avatarInfos.removeAll();
        var index = 0;
        for personInfo in datas {
            if index == 0 {
                var avatar = personInfo.avatar;
                avatar.showBorderColor = true;
                index += 1;
            }
            avatarInfos.append(personInfo.avatar);
        }
        self.header.avatarInfos = avatarInfos;
        self.personInfos = datas;
        self.tableView.reloadData();
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
            let avatarView =
                OLContactAvatarView(frame: viewFrame);
            avatarView.updataWithVO(VO: avatarInfos[index]);
            return avatarView;
        }
    }
    
    func didSelectItems(sourceOLScrollView:OLScrollView, index: Int) {
        scrollViewSelectAt(sourceOLScrollView, index)
        sourceOLScrollView.scrollToIndex(index: index, animated: true)
    }
    
    func scrollViewDidScroll(sourceOLScrollView:OLScrollView) {
        let index = Int(floor(sourceOLScrollView.contentOffset().x / OLHeaderItemViewWidth + 0.5)) ;
        if index != lastSelectedIndex {
            scrollViewSelectAt(sourceOLScrollView, index)
        }
        if let masterView = self.masterView, masterView == sourceOLScrollView {
            self.tableView.setContentOffset(CGPoint(x: 0, y: sourceOLScrollView.contentOffset().x * cellHeight() / OLHeaderItemViewWidth), animated: false);
        }
    }

    
    fileprivate func scrollViewSelectAt(_ sourceOLScrollView: OLScrollView, _ index: Int) {
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
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personInfos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.reuseIdentifier, for: indexPath) as! OLPersonInfoTableViewCell;
        cell.selectionStyle = .none;
        if self.personInfos.count > indexPath.row {
            let personInfo = self.personInfos[indexPath.row];
            cell.updateVO(personInfo);
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false);
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight();
    }
    
    
    func cellHeight() -> CGFloat {
        self.view.OL_height - headerHittestView.OL_bottom;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView, let masterView = self.masterView, masterView == self.tableView {
            self.header.setContentOffset(CGPoint(x: scrollView.contentOffset.y / cellHeight() * OLHeaderItemViewWidth, y: 0), animated: false);
        }
    }
}
