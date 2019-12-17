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

class TableViewController: UITableViewController, OLContactViewModelDataSourceProtocol, OLScrollViewDelegate {
    private var header:OLScrollView! = nil;
    private var avatarInfos:[OLPersonAvatarModelProtocol] = [];
    private var lastSelectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact";
        self.header = OLScrollView(frame: CGRect(x: 0, y: 0, width: self.view.OL_w, height: OLHeaderItemViewHeight));
        self.header.delegate = self as OLScrollViewDelegate;
        self.header.itemSize = CGSize(width: OLHeaderItemViewWidth, height: OLHeaderItemViewHeight);
        self.view.addSubview(self.header);
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
