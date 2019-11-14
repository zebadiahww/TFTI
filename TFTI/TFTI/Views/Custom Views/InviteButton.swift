//
//  InviteButton.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/13/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

class InviteButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        
    }
    
    func setUpView() {
        self.backgroundColor = .midnight
        self.tintColor = .white
        self.addCornerRadius()
    }
    
    func updateFont(font: String) {
        //do font stuff
    }
}
