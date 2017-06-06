//
//  ChoicesCell.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/1/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class ChoicesCell: BaseCell {
    
    let text: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "futura", size: 20)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var menuChoice: ChoicesObj? {
        didSet {
            text.text = menuChoice?.type
        }
    }
    
    override func setUpCell() {
        self.addSubview(text)
        text.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        text.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        text.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        text.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    
    func setUpCell() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
