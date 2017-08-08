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

extension UIImageView {
    func transparentButton(text: String, fontSize: CGFloat, borderWidth: CGFloat, xInset: CGFloat, yInset: CGFloat, alpha: CGFloat, color: UIColor) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -self.bounds.size.height)
        
        // draw rounded rectangle inset of the buttons entire dimension
        
        color.setStroke()
        let rect = self.bounds.insetBy(dx: xInset, dy: yInset)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        path.lineWidth = borderWidth
        path.stroke()
        
        // draw text
        let attributes = [NSFontAttributeName: fontReno?.withSize(fontSize), NSForegroundColorAttributeName: UIColor.white]
        let size = text.size(attributes: attributes)
        let point = CGPoint(x: (self.bounds.size.width - size.width) / 2.0, y: (self.bounds.size.height - size.height) / 2.0)
        text.draw(at: point, withAttributes: attributes)
        
        // capture the image and end context
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // create image mask
        
        let cgImage = image?.cgImage!
        let bytesPerRow = cgImage?.bytesPerRow
        let dataProvider = cgImage?.dataProvider
        let bitsPerPixel = cgImage?.bitsPerPixel
        let bitsPerComponent = cgImage?.bitsPerComponent
        let width = cgImage?.width
        let height = cgImage?.height
        let mask = cgImage?.masking(CGImage(maskWidth: width!, height: height!, bitsPerComponent: bitsPerComponent!, bitsPerPixel: bitsPerPixel!, bytesPerRow: bytesPerRow!, provider: dataProvider!, decode: nil, shouldInterpolate: false)!)
        
        // create background
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        UIGraphicsGetCurrentContext()!.clip(to: self.bounds, mask: mask!)
        color.withAlphaComponent(alpha).setFill()
        UIBezierPath(rect: self.bounds).fill()
        let background = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // use image
        
        self.image = background
    }
}

func fadeOutTransition(viewControllerToPresent: UIViewController, viewControllerPresenting: UIViewController) {
    if let window = UIApplication.shared.keyWindow {
        let blackView = UIView()
        blackView.frame = window.bounds
        blackView.backgroundColor = .black
        blackView.alpha = 0
        window.addSubview(blackView)
        
        UIView.animate(withDuration: 0.3, animations: {
            blackView.alpha = 1
            print("blacking out")
        }, completion: { (_) in
            
            viewControllerPresenting.present(viewControllerToPresent, animated: false, completion: {
                UIView.animate(withDuration: 0.3, animations: {
                    blackView.alpha = 0.0
                }, completion: { (_) in
                    blackView.removeFromSuperview()
                })
            })
        })
    }
}

func setUpBackButton(buttonSize: CGFloat, function: Selector, view: UIView, target: Any) {
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor(white: 1.0, alpha: 0.85).cgColor
        button.layer.borderWidth = 4
        button.layer.cornerRadius = buttonSize / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.addTarget(target, action: function, for: .touchUpInside)
        return button
    }()
    
    view.addSubview(backButton)
    backButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
    backButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
    backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
    backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
}
