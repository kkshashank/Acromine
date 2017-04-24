//
//  CustomUIButton.swift
//  Acromine
//
//  Created by Shashank Kumar on 4/24/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import UIKit

@IBDesignable
class CustomUIButton: UIButton {
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
}
