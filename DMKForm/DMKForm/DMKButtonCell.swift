//
//  DMKButtonCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/26/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKButtonCellInfo: DMKFormCellInfo {
    var titleColor: UIColor = UIColor.blackColor()
    static func create(tag: String, title: String, formVC: DMKFormViewController) -> DMKButtonCellInfo {
        return DMKButtonCellInfo(tag: tag, title: title, type: String(DMKButtonCell.self), value: nil, options: nil, formVC: formVC)
    }
}
class DMKButtonCell: DMKFormCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func configCell() {
        self.update()
    }
    
    override func update() {
        guard let cellInfo: DMKButtonCellInfo = self.cellInfo as? DMKButtonCellInfo, let title = self.cellInfo?.title, let formVC = self.cellInfo?.formViewController else { return }
        
        self.button.enabled = !cellInfo.disable
        
        self.button.setAttributedTitle(NSAttributedString(string: title, attributes: [
            NSForegroundColorAttributeName: cellInfo.titleColor,
            NSFontAttributeName: formVC.titleFont
            ]), forState: .Normal)
        self.button.setAttributedTitle(NSAttributedString(string: title, attributes: [
            NSForegroundColorAttributeName: formVC.detailColor,
            NSFontAttributeName: formVC.titleFont
            ]), forState: .Selected)
        self.button.setAttributedTitle(NSAttributedString(string: title, attributes: [
            NSForegroundColorAttributeName: formVC.detailColor,
            NSFontAttributeName: formVC.titleFont
            ]), forState: .Highlighted)
        self.button.setAttributedTitle(NSAttributedString(string: title, attributes: [
            NSForegroundColorAttributeName: formVC.titleColor,
            NSFontAttributeName: formVC.titleFont
            ]), forState: .Disabled)
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        guard self.cellInfo?.disable == false else { return }
        if let block = self.cellInfo?.actionBlock {
            block(cellInfo: self.cellInfo!)
        }
    }
}
