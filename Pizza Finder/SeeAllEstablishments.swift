//
//  SeeAllEstablishments.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/16/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class SeeAllEstablishments: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showCards))
        self.addGestureRecognizer(tap)
    }
    
    func showCards() {
        print("show cards")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
