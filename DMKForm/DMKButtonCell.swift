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

    override func update() {
        guard let title = self.title, let form = self.form else { return }
        self.button.setAttributedTitle(NSAttributedString(string: title, attributes: [
                NSForegroundColorAttributeName: form.tintColor,
                NSFontAttributeName: form.titleFont
            ]), forState: .Normal)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func disableCell() {
        self.button.enabled = !self.cellInfo!.disable
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        guard self.cellInfo?.disable == false else { return }
        if let block = self.cellInfo?.actionBlock {
            block(cell: self)
        }
    }
}
