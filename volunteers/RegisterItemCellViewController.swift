//
//  RegisterItemCellViewController.swift
//  volunteers
//
//  Created by 陳慶耀 on 2019/12/9.
//  Copyright © 2019 taiwanmobile. All rights reserved.
//

import Foundation

@objc class RegisterItemCellViewController: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var maxNumberLabel: UILabel?
    @IBOutlet var currentNumberTextField: UITextField?
    @IBOutlet var addButton: UIButton?
    @IBOutlet var minusButton: UIButton?
    
    var title = "" {
        didSet {
            titleLabel?.text = title
        }
    }
    
    @objc var maxNumber = 0 {
        didSet {
            maxNumberLabel?.text = "(剩餘 \(maxNumber))"
        }
    }
    @objc var onAddTouched = {}
    @objc var onMinusTouched = {}
    @objc var onValueChanged = { (newValue: Int) in }
    
    @IBAction func addButtonDidTouched() {
        onAddTouched()
        
    }
    @IBAction func minusButtonDidTouched() {
        onMinusTouched()
    }
    
    @IBAction func currentNumberDidChanged() {
        print("currentNumberDidChanged: \(currentNumberTextField!)")
        let newValue =
            Int(currentNumberTextField?.text ?? "0") ?? 0
        
        onValueChanged(newValue)
    }
    
}


