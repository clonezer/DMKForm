//
//  DMKButtonCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/26/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKButtonCell: DMKFormCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func update() {
        guard let title = self.title else { return }
        self.button.setAttributedTitle(NSAttributedString(string: title, attributes: [
                NSForegroundColorAttributeName: self.form!.tintColor,
                NSFontAttributeName: self.form!.titleFont
            ]), forState: .Normal)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        if let block = self.actionBlock {
            block(cell: self)
        }
    }
}
