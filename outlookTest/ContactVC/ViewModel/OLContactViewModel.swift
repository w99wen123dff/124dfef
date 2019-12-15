//
//  OLContactViewModel.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/15.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

protocol OLContactViewModelDataSourceProtocol {
    func allDataChanged(datas:[OLPersonInfoProtocol]);
}

class OLContactViewModel: NSObject {
    private var personInfos:[OLPersonInfoProtocol];
    private let queue: DispatchQueue;
    private var trueDelegate: OLContactViewModelDataSourceProtocol?
    
    var delegate: OLContactViewModelDataSourceProtocol? {
        get {
            return self.trueDelegate;
        }
        set {
            self.trueDelegate = newValue;
            if let tmp = newValue, self.personInfos.count > 0  {
                tmp.allDataChanged(datas: self.personInfos);
            }
        }
    };
    static let instance: OLContactViewModel = OLContactViewModel();
    
    static func sharedInstance() -> OLContactViewModel{
        return instance;
    }
    
    override init() {
        self.personInfos = [];
        self.queue = DispatchQueue(label: "com.ol.contact.viewmodel");
        super.init();
        self.perpareData {
            if let delegate = self.delegate {
                delegate.allDataChanged(datas: self.personInfos);
            }
        };
    }
    
    private func perpareData(completionCallback:@escaping () -> Void) {
        self.queue.async {
            let DOs: [[String:String]] = OLFIleLoader.readLocalData(fileNameStr: "Resource.bundle/contacts", type: "json") as! [[String : String]];
            for DO in DOs {
                let VO: OLPersonInfoModel = OLPersonInfoModel(data: DO);
                self.personInfos.append(VO);
            }
            DispatchQueue.main.async {
                completionCallback();
            }
        }
    }
    
    
}
