//
//  DMKSwitchCell.swift
//  HomeMadeStay
//
//  Created by Peerasak Unsakon on 9/9/16.
//  Copyright © 2016 Fire One One Co.,Ltd. All rights reserved.
//

import UIKit

class DMKSwitchCellInfo: DMKFormCellInfo {
    static func create(tag: String, title: String, value: Bool?, formVC: DMKFormViewController) -> DMKSwitchCellInfo {
        return DMKSwitchCellInfo(tag: tag, title: title, type: String(DMKSwitchCell.self), value: value, options: nil, formVC: formVC)
    }
}

class DMKSwitchCell: DMKFormCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configCell() {
        guard let formVC = self.cellInfo?.formViewController else { return }
        
        self.titleLabel.font = formVC.titleFont
        self.titleLabel.textColor = formVC.titleColor
        self.switchControl.onTintColor = formVC.tintColor
        self.contentView.backgroundColor = formVC.cellColor
        
        self.update()
    }
    
    override func update() {
        guard let cellInfo = self.cellInfo, let value = self.cellInfo?.value as? Bool else { return }
        self.titleLabel.text = cellInfo.title
        self.switchControl.setOn(value, animated: true)
    }
    
    @IBAction func switchDidChanged(sender: AnyObject) {
        guard let cellInfo = self.cellInfo, let switchControl = sender as? UISwitch else { return }
        cellInfo.value = switchControl.on
        if let changeBlock = cellInfo.onChangeBlock {
            changeBlock(value: cellInfo.value!, cellInfo: cellInfo)
        }
        self.update()
    }
    
}
