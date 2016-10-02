//
//  DMKPushCell.swift
//  HomeMadeStay
//
//  Created by Peerasak Unsakon on 10/1/16.
//  Copyright © 2016 Fire One One Co.,Ltd. All rights reserved.
//

import UIKit

class DMKPushCellInfo: DMKFormCellInfo {
    static func create(tag: String, title: String, value: AnyObject?, formVC: DMKFormViewController) -> DMKPushCellInfo {
        return DMKPushCellInfo(tag: tag, title: title, type: String(DMKPushCell.self), value: value, options: nil, formVC: formVC)
    }
}

class DMKPushCell: DMKFormCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configCell() {
        guard let formVC = self.cellInfo?.formViewController else { return }
        
        self.titleLabel.font = formVC.titleFont
        self.titleLabel.textColor = formVC.titleColor
        self.detailLabel.font = formVC.detailFont
        self.detailLabel.textColor = formVC.detailColor
        self.contentView.backgroundColor = formVC.cellColor
        
        self.update()
    }
    
    override func update() {
        guard let cellInfo = self.cellInfo else { return }
        
        self.titleLabel.text = cellInfo.title
        self.detailLabel.text = cellInfo.value as? String
    }
}
