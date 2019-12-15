//
//  OLImageModelProtocol.h
//  outlookTest
//
//  Created by w99wen on 2019/12/14.
//  Copyright © 2019 w99wen. All rights reserved.
//

import Foundation

enum OLImageModelSourceType {
    case OLImageModelSourceTypeUnknown;
    case OLImageModelSourceTypeLocal;
    case OLImageModelSourceTypeURL;
    case OLImageModelSourceTypeIconFont;
}

protocol OLImageModelProtocol {
    var imageSourceType: OLImageModelSourceType { get };
    var imagePath: String { get };
}
