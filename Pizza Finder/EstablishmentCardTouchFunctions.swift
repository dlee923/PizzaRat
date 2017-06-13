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
        let tap = UITapGestureRecognizer(target: self, action: #selector(pullUpMap))
        self.addGestureRecognizer(tap)
    }
    
    func pullUpMap() {
        let mapView = MapViewVC()
        mapView.currentPlace = self.currentLocation
        mapView.selectedPlace = self.establishment
        fadeOutTransition(viewControllerToPresent: mapView, viewControllerPresenting: self.establishmentChoicesVC!)
    }    


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cardCenter = self.center
        if let touch = touches.first {
            touchPoint = touch.location(in: self)
            superTouchPoint = touch.location(in: establishmentChoicesVC?.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            xDifference = touch.location(in: self).x - touchPoint!.x
            yDifference = touch.location(in: self).y - touchPoint!.y
            print(touch.location(in: self).x)
            
            
            
            if touch.location(in: self.establishmentChoicesVC?.view).x > ((self.establishmentChoicesVC?.view.frame.width)! * (1-edgeTarget)) {
                self.alpha = ((self.establishmentChoicesVC?.view.frame.width)! * (1-edgeTarget)) / touch.location(in: self.establishmentChoicesVC?.view).x
                
            } else {
                self.alpha = touch.location(in: self.establishmentChoicesVC?.view).x / ((self.establishmentChoicesVC?.view.frame.width)! * edgeTarget)
                
            }
            
            self.center = CGPoint(x: self.center.x + xDifference!, y: self.center.y + yDifference!)
            //            setCardRotation(rotationAngle: desiredRotationAngle * (.pi/180), center: superTouchPoint!, current: touch.location(in: establishmentChoicesVC?.view))
        }
        
        
        //        print(self.center.x)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let lastTouch = touches.first?.location(in: self.superview) else { return }
        
        if lastTouch.x > ((self.establishmentChoicesVC?.view.frame.width)! * (1-edgeTarget)) {
            if lastTouch.y > (superTouchPoint?.y)! {
                moveOffScreen(directionIsRight: true, directionIsUp: true)
            } else {
                moveOffScreen(directionIsRight: true, directionIsUp: false)
            }
            
        } else if lastTouch.x < ((self.establishmentChoicesVC?.view.frame.width)! * edgeTarget) {
            if lastTouch.y > (superTouchPoint?.y)! {
                moveOffScreen(directionIsRight: false, directionIsUp: true)
            } else {
                moveOffScreen(directionIsRight: false, directionIsUp: false)
            }
            
        } else {
            UIView.animate(withDuration: cardSpeed, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.center = self.cardCenter!
                self.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    func moveOffScreen(directionIsRight: Bool, directionIsUp: Bool) {
        
        var newCenter: CGPoint?
        var yPoint: CGFloat?
        
        yPoint = directionIsUp ? (self.establishmentChoicesVC?.view.frame.height)! * (1 - verticalSwing) : (self.establishmentChoicesVC?.view.frame.height)! * verticalSwing
        
        if directionIsRight {
            newCenter = CGPoint(x: self.center.x + ((self.establishmentChoicesVC?.view.frame.width)! * 0.25) + (self.cardWidth! * 0.5), y: yPoint!)
        } else {
            newCenter = CGPoint(x: self.center.x - ((self.establishmentChoicesVC?.view.frame.width)! * 0.25) - (self.cardWidth! * 0.5), y: yPoint!)
        }
        
        UIView.animate(withDuration: cardSpeed, animations: {
            self.center = newCenter!
        }, completion: { _ in
            self.popNextCard()
        })
    }
    
    func popNextCard() {
        self.removeFromSuperview()
        self.establishmentChoicesVC?.resizeNextCard()
        self.establishmentChoicesVC?.dismissView()
    }
    
    func setCardRotation(rotationAngle: CGFloat, center: CGPoint, current: CGPoint) {
        let distanceFromCenter = abs(current.x - center.x)
        let distanceToTravel = (establishmentChoicesVC?.view.frame.width)!/2
        let rotationPct = distanceFromCenter / distanceToTravel
        let maxAngle = rotationAngle * rotationPct
        self.transform = CGAffineTransform(rotationAngle: maxAngle)
    }
    
}
