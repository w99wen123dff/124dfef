//
//  OLPersonFullNameModel.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/15.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

class OLPersonFullNameModel: NSObject, OLPersonFullNameModelProtocol {
    var firstName: String = ""
    
    var lastName: String = ""
    
    var defaultFullName: String = ""
    
    func fullName(separator: String) -> String {
        return firstName + separator + lastName;
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.defaultFullName = firstName + " " + lastName;
    }
}
