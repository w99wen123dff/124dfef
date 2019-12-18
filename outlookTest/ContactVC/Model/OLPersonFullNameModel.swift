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
    
    func fullName(separator: String) -> String {
        return firstName + separator + lastName;
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName;
        self.lastName = lastName;
    }
    
    init(data: [String:String]) {
        if let firstName = data["first_name"] {
            self.firstName = firstName;
        } else {
            assert(false, "firstName dont exst");
        }
        
        if let lastName = data["last_name"] {
            self.lastName = lastName;
        } else {
            assert(false, "lastName dont exst");
        }
    }
}
