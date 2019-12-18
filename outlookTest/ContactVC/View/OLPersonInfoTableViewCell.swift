//
//  OLPersonInfoTableViewCell.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/18.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

func screenWidth() -> CGFloat {
    return UIScreen.main.bounds.size.width;
}

class OLPersonInfoTableViewCell: UITableViewCell {
    private var personInfo: OLPersonInfoProtocol?;
    private let nameLabel = UILabel();
    private let titleLabel = UILabel();
    private let aboutLabel = UILabel();
    private let detailLabel = UILabel();
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.contentView.addSubview(nameLabel);
        self.contentView.addSubview(titleLabel);
        self.contentView.addSubview(aboutLabel);
        self.contentView.addSubview(detailLabel);
        
        updateFrame();
    }
    
    func updateVO(_ personInfo: OLPersonInfoProtocol) {
        self.personInfo = personInfo;
        updateNameLabelText();
        updateTitleLabel()
        updateDetailLabelText()
    }
    
    private func updateFrame() {
        updateNameLabelFrame()
        updateTitleLabel()
        updateAboutLabel()
    }
    
    
    private func updateNameLabelFrame() {
        nameLabel.OL_top = 33;
        nameLabel.OL_left = 0;
        nameLabel.OL_width = screenWidth();
        nameLabel.textAlignment = .center
        nameLabel.OL_height = 20;
    }
    
    private func updateTitleLabel() {
        titleLabel.OL_top = nameLabel.OL_bottom + 25;
        titleLabel.OL_left = 0;
        titleLabel.OL_width = screenWidth();
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.lightGray;
        titleLabel.font = UIFont.systemFont(ofSize: 16);
        titleLabel.OL_height = 17;
    }
    
    private func updateAboutLabel() {
        aboutLabel.OL_top = titleLabel.OL_bottom + 31;
        aboutLabel.OL_left = 20;
        aboutLabel.OL_height = 13;
        aboutLabel.OL_width = screenWidth() - aboutLabel.OL_left * 2;
        aboutLabel.font = UIFont.boldSystemFont(ofSize: 13);
        aboutLabel.text = "About me"
    }
    
    private func updateDetailLabel() {
        detailLabel.OL_top = aboutLabel.OL_bottom + 11;
        detailLabel.OL_left = aboutLabel.OL_left;
        detailLabel.OL_width = screenWidth() - detailLabel.OL_left * 2;
        detailLabel.font = UIFont.systemFont(ofSize: 12);
        detailLabel.numberOfLines = 0;
        detailLabel.OL_height = self.contentView.OL_height - detailLabel.OL_top;
    }
    
    private func updateNameLabelText() {
        let seperator = " ";
        if let personInfo = self.personInfo {
            let name = NSMutableAttributedString(string: "");
            let firstName = NSAttributedString(string: personInfo.name.firstName, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 19), NSAttributedString.Key.foregroundColor: UIColor.black]);
            
            name.append(firstName);
            
            name.append(NSAttributedString(string: seperator, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19), NSAttributedString.Key.foregroundColor: UIColor.black]));
            
            let lastName = NSAttributedString(string: personInfo.name.lastName, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19), NSAttributedString.Key.foregroundColor: UIColor.black]);
            
            name.append(lastName);
            
            nameLabel.attributedText = name;
        } else {
            nameLabel.attributedText = nil;
        }
    }
    
    private func updateTitleLabelText() {
        if let personInfo = self.personInfo {
            titleLabel.text = personInfo.title;
        } else {
            titleLabel.text = nil;
        }
    }
    
    private func updateDetailLabelText() {
        if let personInfo = self.personInfo {
            detailLabel.text = personInfo.introduction;
        } else {
            detailLabel.text = nil;
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
