//
//  OLPersonNameModelProtocol.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/14.
//  Copyright © 2019 w99wen. All rights reserved.
//

import Foundation

protocol OLPersonFullNameModelProtocol {
    var firstName: String { get };
    var lastName: String { get };
    
    func fullName(separator: String) -> String;
}
