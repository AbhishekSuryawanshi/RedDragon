//
//  UIImageView+Extension.swift
//  RedDragon
//
//  Created by Qasr01 on 24/11/2023.
//

import UIKit
import SDWebImage

extension UIImageView {
    /// To set image and its activity indicator from image url
    func setImage(imageStr: String, placeholder: UIImage? = nil) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if placeholder != nil {
            self.sd_setImage(with: URL(string: imageStr), placeholderImage: placeholder)
        } else {
            self.sd_setImage(with: URL(string: imageStr))
        }
    }
}
