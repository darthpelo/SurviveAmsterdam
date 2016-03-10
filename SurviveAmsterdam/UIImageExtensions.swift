//  Created by Sem Shafiq on 11/12/15.


import Foundation
import UIKit

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