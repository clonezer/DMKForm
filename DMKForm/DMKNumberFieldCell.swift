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
        
    }
    
    override func configCell() {
        guard let formVC = self.cellInfo?.formViewController else { return }
        self.titleLabel.font = formVC.titleFont
        self.titleLabel.textColor = formVC.titleColor
        self.textField.font = formVC.detailFont
        self.textField.textColor = formVC.detailColor
        self.contentView.backgroundColor = formVC.cellColor
        self.update()
    }
    
    override func update() {
        guard let cellInfo = self.cellInfo else { return }
        
        cellInfo.actionBlock = { cell in
            self.textField.becomeFirstResponder()
        }
        
        self.titleLabel.text = cellInfo.title
        guard let value = cellInfo.value else {
            cellInfo.value = 0
            return
        }
        self.textField.text = "\(value as! Double)"
        self.textField.enabled = !cellInfo.disable
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension DMKNumberFieldCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard let value = textField.text else {
            self.cellInfo?.value = 0
            return
        }
        
        if let num = Double(value) {
            self.cellInfo?.value = num
        }else {
            self.cellInfo?.value = 0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
