//
//  UIImageView+.swift
//  MovieTest
//
//  Created by Tinh Vu on 11/29/18.
//  Copyright © 2018 Tinh Vu. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ path: String, isLarge: Bool = false) {
        let urlString = Config.IMAGE_BASE_URL + (isLarge ? "w780" : "w185") + path
        if let url = URL(string: urlString) {
            self.kf.setImage(with: url)
        }
    }
}
