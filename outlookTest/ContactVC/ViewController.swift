//
//  TableViewController.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/14.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OLContactViewModelDataSourceProtocol, OLHeaderComponentProtocl, UITableViewDelegate, UITableViewDataSource {
    
    private var header:OLHeaderComponent! = nil;
    private var personInfos:[OLPersonInfoProtocol] = [];
    private let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0), style: UITableView.Style.plain);
    private var tableHittestView: UIView!;
    
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
        
        self.header = OLHeaderComponent(frame: CGRect(x: 0, y: top, width: self.view.OL_width, height: OLHeaderItemViewHeight));
        self.header.delegate = self as OLHeaderComponentProtocl;
        self.header.itemSize = CGSize(width: OLHeaderItemViewWidth, height: OLHeaderItemViewHeight);
        self.view.addSubview(header);
        OLMasterViewTester.sharedInstance
        
        self.tableView.register(OLPersonInfoTableViewCell.self, forCellReuseIdentifier: reuseIdentifier);
        self.tableView.OL_top = header.OL_bottom
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = .none;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        self.tableView.delegate = self;
        self.tableView.isPagingEnabled = true;
        self.tableView.dataSource = self;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.OL_height = self.view.OL_height - header.OL_bottom;
        tableHittestView = OLCustomHitTestView(self.tableView.frame) { (hittedView) in
            if hittedView != nil {
                OLEventDispatcher.sharedInstance.dispatchEvent(OLBaseEvent(name: "com.ol.action.obtainFirstResponder", source: "TableViewComponent", data: ["view": self.tableView]));
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
        var avatarInfos = [OLPersonAvatarModelProtocol]();
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
    
    //MARK: - OLHeaderComponentProtocl
    
    func didSelectItems(sourceOLScrollView:OLHeaderComponent, index: Int) {
        
    }
    
    func scrollViewDidScroll(sourceOLScrollView:OLHeaderComponent) {
        if OLMasterViewTester.sharedInstance.isViewMasterView(self.header) {
            self.tableView.setContentOffset(CGPoint(x: 0, y: sourceOLScrollView.contentOffset.x * cellHeight() / OLHeaderItemViewWidth), animated: false);
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! OLPersonInfoTableViewCell;
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
        self.view.OL_height - header.OL_bottom;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView, OLMasterViewTester.sharedInstance.isViewMasterView(self.tableView) {
            self.header.setContentOffset(CGPoint(x: scrollView.contentOffset.y / cellHeight() * OLHeaderItemViewWidth, y: 0), animated: false);
        }
    }
}
