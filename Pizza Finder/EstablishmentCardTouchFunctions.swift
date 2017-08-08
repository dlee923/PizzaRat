//
//  EstablishmentCardTouchFunctions.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/8/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

extension EstablishmentCard {
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(locateEstablishment))
        self.addGestureRecognizer(tap)
    }
    
    func locateEstablishment() {
        
        guard let directions = self.establishment.directions else { return }
        mapViewVC?.mapView.traceDirection(wayPoints: directions)
        mapViewVC?.slideCardView(isUp: false)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cardCenter = self.center
        if let touch = touches.first {
            touchPoint = touch.location(in: self)
            superTouchPoint = touch.location(in: mapViewVC?.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            xDifference = touch.location(in: self).x - touchPoint!.x
            
            self.center = CGPoint(x: self.center.x + xDifference!, y: self.center.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let lastTouch = touches.first?.location(in: self.superview) else { return }
        
        if lastTouch.x > ((mapViewVC?.view.frame.width)! * (1-edgeTarget)) {
            moveOffScreen(directionIsRight: true)
        } else if lastTouch.x < ((mapViewVC?.view.frame.width)! * edgeTarget) {
            moveOffScreen(directionIsRight: false)
            
        } else {
            UIView.animate(withDuration: cardSpeed, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                self.center = self.cardCenter!
                self.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    func moveOffScreen(directionIsRight: Bool) {
        
        var newCenter: CGPoint?
        
        if directionIsRight {
            newCenter = CGPoint(x: self.center.x + ((mapViewVC?.view.frame.width)! * 0.25) + (self.cardWidth! * 0.5), y: self.center.y)
        } else {
            newCenter = CGPoint(x: self.center.x - ((mapViewVC?.view.frame.width)! * 0.25) - (self.cardWidth! * 0.5), y: self.center.y)
        }
        
        UIView.animate(withDuration: cardSpeed, animations: {
            self.center = newCenter!
        }, completion: { _ in
            self.popNextCard()
        })
    }
    
    func popNextCard() {
        self.removeFromSuperview()
        establishmentsView?.resizeNextCard()
        establishmentsView?.dismissView()
    }
    
    func setCardRotation(rotationAngle: CGFloat, center: CGPoint, current: CGPoint) {
        let distanceFromCenter = abs(current.x - center.x)
        let distanceToTravel = (mapViewVC?.view.frame.width)!/2
        let rotationPct = distanceFromCenter / distanceToTravel
        let maxAngle = rotationAngle * rotationPct
        self.transform = CGAffineTransform(rotationAngle: maxAngle)
    }
    
}
