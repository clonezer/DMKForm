//
//  DMKTextfieldCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKTextfieldCellInfo: DMKFormCellInfo {
    
    var placeholder: String?
    
    override init(tag: String, title: String, type: String, value: AnyObject?, options: [AnyObject]?, formVC: DMKFormViewController) {
        super.init(tag: tag, title: title, type: type, value: value, options: options, formVC: formVC)
    }
}

class DMKTextfieldCell: DMKFormCell {

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
        guard let cellInfo = self.cellInfo as? DMKTextfieldCellInfo else { return }
        
        cellInfo.actionBlock = { cell in
            self.textField.becomeFirstResponder()
        }
        
        self.showError()
        
        self.titleLabel.text = cellInfo.title
        self.textField.placeholder = cellInfo.placeholder
        self.titleLabel.text = cellInfo.title
        self.textField.text = cellInfo.value as? String
        self.textField.enabled = !cellInfo.disable
    }
    
    override func showError() {
        guard
            let cellInfo = self.cellInfo as? DMKTextfieldCellInfo,
            let formVC = self.cellInfo?.formViewController
            else { return }
        
        if cellInfo.validate == false {
            self.titleLabel.textColor = UIColor.redColor()
        }else {
            self.titleLabel.textColor = formVC.titleColor
        }
    }
        
}

extension DMKTextfieldCell: UITextFieldDelegate {

    func textFieldDidEndEditing(textField: UITextField) {
        
        guard let cellInfo = self.cellInfo else { return }
        
        cellInfo.value = textField.text
        self.update()

        if let validatorBlock = cellInfo.validatorBlock {
            cellInfo.validate = validatorBlock(cellInfo: cellInfo)
        }
        
        if let changeBlock = cellInfo.onChangBlock {
            changeBlock(value: textField.text!)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
