//
//  DefinitionTableViewCell.swift
//  Acromine
//
//  Created by Shashank Kumar on 4/24/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import UIKit

class DefinitionTableViewCell: UITableViewCell {
    
    func configureCell(title: String){
        textLabel?.text = title
        textLabel?.adjustsFontSizeToFitWidth = true
    }
}
