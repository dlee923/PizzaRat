//
//  HomescreenVCCollectionV.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/1/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

extension HomescreenVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: choicesCellID, for: indexPath) as? ChoicesCell {
            cell.menuChoice = choices[indexPath.item]
            if nightMode {
                cell.backgroundColor = UIColor(white: 0, alpha: 0.9)
            } else {
                cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let establishmentChoicesVC = EstablishmentChoicesVC()
        present(establishmentChoicesVC, animated: true, completion: nil)
//        pullNearbyRestaurants(food: choices[indexPath.item].type)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / (scrollView.contentSize.width / CGFloat(foodChoices.numberOfItems(inSection: 0))))
        print(page)
        UIView.animate(withDuration: durationColorBackground) {
            self.foodChoices.backgroundColor = self.choices[page].backgroundColor
        }
    }
}
