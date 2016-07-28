//
//  DMKStepperCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/26/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKStepperCell: DMKFormCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    var minimumValue = 0
    var maximumValue = 999
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func update() {
        
        guard let title = self.title, let value = self.value, let cellInfo = self.cellInfo else { return }
        
        self.titleLabel.font = cellInfo.formViewController?.titleFont
        self.titleLabel.textColor = cellInfo.formViewController?.titleColor
        self.valueLabel.font = cellInfo.formViewController?.detailFont
        self.valueLabel.textColor = cellInfo.formViewController?.detailColor
        self.contentView.backgroundColor = cellInfo.formViewController?.cellColor
        
        self.titleLabel.text = title
        self.valueLabel.text = "\(value as! Int)"
    }
    
    override func disableCell() {
        plusButton.enabled = !self.cellDisable
        minusButton.enabled = !self.cellDisable
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func plusButtonTapped(sender: AnyObject) {
        var value = self.value as! Int
        if value < self.maximumValue {
            value = value + 1
        }
        self.value = value
        self.update()
    }
    
    @IBAction func minusButtonTapped(sender: AnyObject) {
        var value = self.value as! Int
        if value > self.minimumValue {
            value = value - 1
        }
        self.value = value
        self.update()
    }
    
}
