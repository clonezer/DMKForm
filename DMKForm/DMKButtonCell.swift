//
//  DMKButtonCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/26/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKButtonCellInfo: DMKFormCellInfo {

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
        guard let cellInfo = self.cellInfo, let title = self.cellInfo?.title, let formVC = self.cellInfo?.formViewController else { return }
        self.button.setAttributedTitle(NSAttributedString(string: title, attributes: [
            NSForegroundColorAttributeName: formVC.tintColor,
            NSFontAttributeName: formVC.titleFont
            ]), forState: .Normal)
        self.button.enabled = !cellInfo.disable
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        guard self.cellInfo?.disable == false else { return }
        if let block = self.cellInfo?.actionBlock {
            block(cell: self)
        }
    }
}
