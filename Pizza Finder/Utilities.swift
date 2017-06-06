//
//  Utilities.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/4/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

let fontReno = UIFont(name: "Renogare", size: 5)

extension NSLayoutDimension {
    func dimensionConstraintWithIdentifier(heightOrWidth: NSLayoutDimension, multiplier: CGFloat, id: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: heightOrWidth, multiplier: multiplier)
        constraint.identifier = id
        return constraint
    }
}

extension NSLayoutXAxisAnchor {
    func axisConstraintWithIdentifier(axis: NSLayoutXAxisAnchor, constant: CGFloat, id: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: axis, constant: constant)
        constraint.identifier = id
        return constraint
    }
}

extension NSLayoutYAxisAnchor {
    func axisConstraintWithIdentifier(axis: NSLayoutYAxisAnchor, constant: CGFloat, id: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: axis, constant: constant)
        constraint.identifier = id
        return constraint
    }
}
