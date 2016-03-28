

import Foundation
import UIKit
import CoreLocation
import QuadratTouch

//  Created by Sem Shafiq on 11/12/15.
extension UIImage {
    public func resizeByWidth(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        self.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    public func resizeByHeight(newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        self.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIImageView {
    /**
     Convert the image of UIImageView in NSData, if presents
     
     - returns: Optional NSData rappresentation of the image
     */
    public func convertImageToData() -> NSData? {
        guard let image = self.image else {
            return nil
        }
        return UIImageJPEGRepresentation(image, 1)
    }
}

extension CLLocation {
    func parameters() -> Parameters
    {
        let ll      = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let llAcc   = "\(self.horizontalAccuracy)"
        let alt     = "\(self.altitude)"
        let altAcc  = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}

extension UIViewController {
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension String {
    var length: Int {
        return characters.count
    }
}