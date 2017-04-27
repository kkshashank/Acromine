//
//  ActivitySpinner.swift
//  Acromine
//
//  Created by Shashank Kumar on 4/24/17.
//  Copyright © 2017 Shashank. All rights reserved.
//


import UIKit

extension UIViewController {
    func activityIndicatorSetup(viewTo: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        activityIndicator.color = UIColor.white
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        viewTo.addSubview(activityIndicator)
        activityIndicator.center = viewTo.center
        activityIndicator.layer.cornerRadius = 20
        activityIndicator.layer.shadowOffset.height = 3
        activityIndicator.layer.shadowOffset.width = 2
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }
}
