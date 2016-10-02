//
//  DMKStepperCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/26/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

typealias DMKStepperButtonTappedBlock = (cellInfo: DMKStepperCellInfo) -> Void

class DMKStepperCellInfo: DMKFormCellInfo {
    var minimumValue = 0
    var maximumValue = 999
    var didMinusButtonTapBlock: DMKStepperButtonTappedBlock?
    var didPlusButtonTapBlock: DMKStepperButtonTappedBlock?
        
    static func create(tag: String, title: String, value: AnyObject?, formVC: DMKFormViewController) -> DMKStepperCellInfo {
        return DMKStepperCellInfo(tag: tag, title: title, type: String(DMKStepperCell.self), value: value, options: nil, formVC: formVC)
    }
}

class DMKStepperCell: DMKFormCell {

    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func configCell() {
        guard let formVC = self.cellInfo?.formViewController else { return }
        
        self.titleLabel.font = formVC.titleFont
        self.titleLabel.textColor = formVC.titleColor
        self.plusButton.titleLabel?.font = formVC.titleFont
        self.minusButton.titleLabel?.font = formVC.titleFont
        self.plusButton.backgroundColor = formVC.tintColor
        self.minusButton.backgroundColor = formVC.detailColor
        self.contentView.backgroundColor = formVC.cellColor
        self.update()
    }
    
    override func update() {
        guard
            let cellInfo = self.cellInfo as? DMKStepperCellInfo,
            let value = cellInfo.value as? Int
            else { return }
        
        cellInfo.value = (value < cellInfo.minimumValue ? cellInfo.minimumValue : value)
        cellInfo.value = (value > cellInfo.maximumValue ? cellInfo.maximumValue : value)
        
        self.titleLabel.text = cellInfo.title
        
        if value < 1 {
            self.plusButton.setTitle("+", forState: .Normal)
        }else {
            self.plusButton.setTitle("\(value)", forState: .Normal)
        }

        self.plusButton.enabled = !cellInfo.disable
        
        self.minusButton.enabled = !cellInfo.disable
        self.minusButton.hidden = (value < 1)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func plusButtonTapped(sender: AnyObject) {
        guard
            let cellInfo = self.cellInfo as? DMKStepperCellInfo,
            let cellValue = cellInfo.value as? Int
            where
            cellInfo.maximumValue > cellValue
            else { return }
        
        cellInfo.value = cellValue + 1
        
        if let changeBlock = cellInfo.onChangeBlock {
            changeBlock(value: cellValue, cellInfo: cellInfo)
        }
        if let plusButtonBlock = cellInfo.didPlusButtonTapBlock {
            plusButtonBlock(cellInfo: cellInfo)
        }
        
        self.update()
    }
    
    @IBAction func minusButtonTapped(sender: AnyObject) {
        guard
            let cellInfo = self.cellInfo as? DMKStepperCellInfo,
            let cellValue = cellInfo.value as? Int
        where
            cellInfo.minimumValue < cellValue
        else { return }
        
        cellInfo.value = cellValue - 1
        
        if let changeBlock = cellInfo.onChangeBlock {
            changeBlock(value: cellValue, cellInfo: cellInfo)
        }
        if let minusButtonBlock = cellInfo.didMinusButtonTapBlock {
            minusButtonBlock(cellInfo: cellInfo)
        }
        self.update()
    }
    
}
