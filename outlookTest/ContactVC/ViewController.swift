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
    
    static let reuseIdentifier = "reuseIdentifier";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact";
        var top:CGFloat = 0;
        if let navigationController = self.navigationController {
            top = navigationController.navigationBar.frame.origin.y + navigationController.navigationBar.frame.size.height;
        }
        self.header = OLScrollView(frame: CGRect(x: 0, y: top, width: self.view.OL_width, height: OLHeaderItemViewHeight));
        self.header.delegate = self as OLScrollViewDelegate;
        self.header.itemSize = CGSize(width: OLHeaderItemViewWidth, height: OLHeaderItemViewHeight);
        self.view.addSubview(self.header);
        
        
        self.tableView.register(OLPersonInfoTableViewCell.self, forCellReuseIdentifier: ViewController.reuseIdentifier);
        self.tableView.OL_top = self.header.OL_bottom
        self.tableView.backgroundColor = UIColor.gray
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.OL_height = self.view.OL_height - self.header.OL_bottom;
        self.view.addSubview(self.tableView);
        
        
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
    
    func didSelectItems(sourceOLScrollView:OLScrollView, index: Int) {
        scrollViewSelectAt(sourceOLScrollView, index)
        sourceOLScrollView.scrollToIndex(index: index, animated: true)
    }
    
    func scrollViewDidScroll(sourceOLScrollView:OLScrollView) {
        let index = Int(floor(sourceOLScrollView.contentOffset().x / OLHeaderItemViewWidth + 0.5)) ;
        if index != lastSelectedIndex {
            scrollViewSelectAt(sourceOLScrollView, index)
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
        if self.personInfos.count > indexPath.row {
            let personInfo = self.personInfos[indexPath.row];
            cell.updateVO(personInfo);
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false);
        //TODO:
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.OL_height - header.OL_bottom;
    }
}
