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
        guard let cellInfo = self.cellInfo else { return }
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
        guard let cellInfo = self.cellInfo else { return }
        
        var value = cellInfo.value as! Int
        if value < self.maximumValue {
            value = value + 1
        }
        cellInfo.value = value
        self.update()
    }
    
    @IBAction func minusButtonTapped(sender: AnyObject) {
        guard let cellInfo = self.cellInfo else { return }
        
        var value = cellInfo.value as! Int
        if value > self.minimumValue {
            value = value - 1
        }
        cellInfo.value = value
        self.update()
    }
    
}
