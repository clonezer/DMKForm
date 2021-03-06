//
//  DMKTextfieldCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKTextfieldCell: DMKFormCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.delegate = self
        self.actionBlock = { cell in
            self.textField.becomeFirstResponder()
        }
    }
    
    override func update() {
        self.titleLabel.font = self.form?.titleFont
        self.titleLabel.textColor = self.form?.titleColor
        self.textField.font = self.form?.detailFont
        self.textField.textColor = self.form?.detailColor
        self.contentView.backgroundColor = self.form?.cellColor
        
        self.titleLabel.text = self.title
        self.textField.text = self.value as? String
    }
    
    override func disableCell() {
        self.textField.enabled = !cellDisable
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DMKTextfieldCell: UITextFieldDelegate {

    func textFieldDidEndEditing(textField: UITextField) {
        self.value = textField.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
