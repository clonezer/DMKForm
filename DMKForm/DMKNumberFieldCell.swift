//
//  DMKNumberFieldCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/26/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKNumberFieldCell: DMKFormCell {

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
        
        guard let value = self.value else {
            self.value = 0
            return
        }
        self.textField.text = "\(value as! Double)"
    }
    
    override func disableCell() {
        self.textField.enabled = !cellDisable
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension DMKNumberFieldCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard let value = textField.text else {
            self.value = 0
            return
        }
        
        if let num = Double(value) {
            self.value = num
        }else {
            self.value = 0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
