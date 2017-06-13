//
//  ChoicesPickerCell.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/7/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class ChoicesPickerCell: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .black
    }
    
    let imageMultiplier: CGFloat = 0.7
    var choice: ChoicesObj? {
        didSet {
            setUpCell(imageName: choice?.optionImageName ?? "")
        }
    }
    let defaultColor = UIColor.black
    
    func setUpCell(imageName: String) {
        let image = UIImageView(image: UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate))
        image.tintColor = defaultColor
        image.contentMode = .scaleAspectFit
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: imageMultiplier).isActive = true
        image.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: imageMultiplier).isActive = true
        image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
