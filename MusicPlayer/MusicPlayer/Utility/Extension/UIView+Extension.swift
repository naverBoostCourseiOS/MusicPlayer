//
//  UIView+Extension.swift
//  MusicPlayer
//
//  Created by hyosung on 2023/02/04.
//

import UIKit

extension UIView {
  func addSubviews(_ views: UIView...) {
    views.forEach(self.addSubview(_:))
  }
}
