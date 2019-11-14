//
//  StyleGuide.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/14/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

extension UIView {
    func addCornerRadius(_ radius: CGFloat = 6) {
        self.layer.cornerRadius = radius
    }
    
    func addAccentBorder(width: CGFloat = 1, color: UIColor = .softblue) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}

extension UIColor {
    static let softblue = UIColor(named: "softblue")!
    static let invitegreen = UIColor(named: "invitegreen")!
    static let invitecopper = UIColor(named: "invitecopper")!
    static let normalpink = UIColor(named: "normalpink")!
    static let midnight = UIColor(named: "midnight")!
}
