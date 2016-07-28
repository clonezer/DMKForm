//
//  DMKStepperCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/26/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKStepperCellInfo: DMKFormCellInfo {
    var minimumValue = 0
    var maximumValue = 999
    
    override init(tag: String, title: String, type: String, value: AnyObject?, options: [AnyObject]?, formVC: DMKFormViewController) {
        super.init(tag: tag, title: title, type: type, value: value, options: options, formVC: formVC)
    }
}

class DMKStepperCell: DMKFormCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func configCell() {
        guard let formVC = self.cellInfo?.formViewController else { return }
        
        self.titleLabel.font = formVC.titleFont
        self.titleLabel.textColor = formVC.titleColor
        self.valueLabel.font = formVC.detailFont
        self.valueLabel.textColor = formVC.detailColor
        self.contentView.backgroundColor = formVC.cellColor
        self.update()
    }
    
    override func update() {
        guard let cellInfo = self.cellInfo as? DMKStepperCellInfo else { return }
        
        cellInfo.value = ((cellInfo.value as! Int) < cellInfo.minimumValue ? cellInfo.minimumValue : cellInfo.value)
        cellInfo.value = ((cellInfo.value as! Int) > cellInfo.maximumValue ? cellInfo.maximumValue : cellInfo.value)
        
        self.titleLabel.text = cellInfo.title
        self.valueLabel.text = "\(cellInfo.value as! Int)"
        self.plusButton.enabled = !cellInfo.disable
        self.minusButton.enabled = !cellInfo.disable
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func plusButtonTapped(sender: AnyObject) {
        guard let cellInfo = self.cellInfo  else { return }
        
        var value = cellInfo.value as! Int
        let max = (cellInfo as! DMKStepperCellInfo).maximumValue
        if value < max {
            value = value + 1
        }
        cellInfo.value = value
        self.update()
    }
    
    @IBAction func minusButtonTapped(sender: AnyObject) {
        guard let cellInfo = self.cellInfo else { return }
        
        var value = cellInfo.value as! Int
        let min = (cellInfo as! DMKStepperCellInfo).minimumValue
        if value > min {
            value = value - 1
        }
        cellInfo.value = value
        self.update()
    }
    
}
