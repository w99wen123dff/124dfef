//
//  OLImageUtility.swift
//  outlookTest
//
//  Created by w99wen on 2019/12/16.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit


extension UIImage {
    
    public func image(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) -> UIImage? {
        return image(radius: radius, corners: UIRectCorner.allCorners, borderWidth: borderWidth, borderColor: borderColor, borderLineJoin: .miter)
    }
    
    public func image(radius: CGFloat, corners: UIRectCorner, borderWidth: CGFloat, borderColor: UIColor, borderLineJoin: CGLineJoin) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -rect.size.height)
        
        let minSize = min(size.width, size.height)
        if borderWidth < minSize / 2 {
            let path = UIBezierPath.init(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: borderWidth))
            path.close()
            
            context?.saveGState()
            path.addClip()
            context?.draw(cgImage!, in: rect)
            context?.restoreGState()
        }
        
        if borderWidth > 0 && borderWidth < minSize / 2 {
            let strokeInset = (floor(borderWidth*scale)+0.5) / scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > scale / 2 ? radius-scale/2 : 0
            
            let path = UIBezierPath.init(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
            path.close()
            
            path.lineWidth = borderWidth
            path.lineJoinStyle = borderLineJoin
            borderColor.setStroke()
            path.stroke()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}


class OLImageOperation: NSObject {
    var invalidated: Bool = false;
    private var completionCallback: (_ image: UIImage?, _ error :NSError?, _ imageInfo:OLImageWithBoraderModel) -> Void;
    
    func invalidate() {
        self.invalidated = true;
    }
    
    func tryCallback(_ image: UIImage?, _ error :NSError?, _ imageInfo:OLImageWithBoraderModel) {
        if !self.invalidated {
            
        }
    }
    
    
    init(callback:@escaping (_ image: UIImage?, _ error :NSError?, _ imageInfo:OLImageWithBoraderModel) -> Void) {
        self.completionCallback = callback;
    }
}

protocol OLImageWithBoraderModelProtocol {
    var imageSource: OLImageModelProtocol { get }
    
    var borderColor: UIColor { get }
    
    var borderWidth: CGFloat  { get }
    
    var radius: CGFloat  { get }
    
    func description() -> String ;
}

class OLImageWithBoraderModel: NSObject, OLImageWithBoraderModelProtocol {
    var imageSource: OLImageModelProtocol
    
    var borderColor: UIColor
    
    var borderWidth: CGFloat
    
    var radius: CGFloat
    
    init(imageSource: OLImageModelProtocol, borderColor: UIColor, borderWidth: CGFloat, radius: CGFloat) {
        self.imageSource = imageSource;
        self.borderColor = borderColor;
        self.borderWidth = borderWidth;
        self.radius = radius;
    }
    
    func description() -> String {
        return "\(self.imageSource.description())|\(self.borderWidth)|\(self.radius)|\(self.borderColor)"
    }
    
    override class func hash() -> Int {
        return self.description().hashValue;
    }
}

class OLImageUtility: NSObject {
    
    static func loadImage(imageInfo: OLImageWithBoraderModel, completionCallback:@escaping (_ image: UIImage?, _ error :NSError?, _ imageInfo:OLImageWithBoraderModel) -> Void) -> OLImageOperation {
        
        let operation = OLImageOperation(callback: completionCallback);
        DispatchQueue.global().async {
            if imageInfo.imageSource.imageSourceType == .OLImageModelSourceTypeUnknown {
                if imageInfo.imageSource.imageSourceType == .OLImageModelSourceTypeLocal {
                    if let image = UIImage(named: imageInfo.imageSource.imagePath) {
                        if let modifiedImage = image.image(radius: imageInfo.radius, borderWidth: imageInfo.borderWidth, borderColor: imageInfo.borderColor) {
                            OLTheadSafeRun.runOnMainThread {
                                operation.tryCallback(modifiedImage, nil, imageInfo);
                            }
                        } else {
                            OLTheadSafeRun.runOnMainThread {
                                operation.tryCallback(nil, NSError(domain: "image params is wrong", code: -2, userInfo: nil), imageInfo);
                            }
                        }
                    } else {
                        OLTheadSafeRun.runOnMainThread {
                            operation.tryCallback(nil, NSError(domain: "image name is wrong", code: -1, userInfo: nil), imageInfo);
                        }
                    }
                } else if imageInfo.imageSource.imageSourceType == .OLImageModelSourceTypeURL {
                    OLTheadSafeRun.runOnMainThread {
                        operation.tryCallback(nil, NSError(domain: "OLImageModelSourceTypeURL not support", code: -3, userInfo: nil), imageInfo);
                    }
                } else if imageInfo.imageSource.imageSourceType == .OLImageModelSourceTypeIconFont {
                    OLTheadSafeRun.runOnMainThread {
                        operation.tryCallback(nil, NSError(domain: "OLImageModelSourceTypeIconFont not support", code: -3, userInfo: nil), imageInfo);
                    }
                }
            }
        }
        return operation;
    }
}
