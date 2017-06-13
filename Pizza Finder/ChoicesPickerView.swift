//
//  ChoicesPickerView.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/7/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class ChoicesPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.transform = CGAffineTransform(rotationAngle: -90 * (.pi/180))
        self.delegate = self
        self.dataSource = self
    }
    
    var homescreenVC: HomescreenVC?
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return homescreenVC?.choices.count ?? 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        // height
        return homescreenVC?.foodChoicesPickerHeight ?? 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        // width
        return homescreenVC?.foodChoicesPickerHeight ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = ChoicesPickerCell()
        view.choice = homescreenVC?.choices[row]
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        return view
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
