//
//  DMKNumberFieldCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/26/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit
import Validator

class DMKNumberFieldCellInfo: DMKFormCellInfo {
    
    var placeholder: String?
    
    static func create(tag: String, title: String, value: AnyObject?, formVC: DMKFormViewController) -> DMKNumberFieldCellInfo {
        return DMKNumberFieldCellInfo(tag: tag, title: title, type: String(DMKNumberFieldCell.self), value: value, options: nil, formVC: formVC)
    }
}

class DMKNumberFieldCell: DMKFormCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
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
        guard let cellInfo = self.cellInfo as? DMKNumberFieldCellInfo else { return }
        
        cellInfo.actionBlock = { cell in
            self.textField.becomeFirstResponder()
        }
        
        self.textField.validationRules = cellInfo.validationRuleSet
        self.textField.validateOnInputChange(true)
        self.textField.validationHandler = { result, sender in self.updateValidationState(result) }
        
        self.titleLabel.text = cellInfo.title
        self.textField.placeholder = cellInfo.placeholder
        guard let value = cellInfo.value else {
            cellInfo.value = 0
            return
        }
        self.textField.text = "\(value as! Double)"
        self.textField.enabled = !cellInfo.disable
        
        if cellInfo.validationErrors?.isEmpty == false {
            let messages = cellInfo.validationErrors
            let message = messages!.joinWithSeparator(" and ")
            self.showError(message)
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func showError(message: String) {
        self.errorLabel.text = message
        self.errorView.hidden = false
    }
    
    func clearError() {
        self.errorLabel.text = ""
        self.errorView.hidden = true
        self.cellInfo?.validationErrors?.removeAll()
    }
    
    func updateValidationState(result: ValidationResult) {
        switch result {
        case .Valid:
            self.cellInfo?.validate = true
            self.clearError()
        case .Invalid(let failures):
            let messages = failures.map { $0.message }
            self.cellInfo?.validate = false
            let message = messages.joinWithSeparator(" and ")
            self.showError(message)
        }
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
        
        if let changeBlock = self.cellInfo?.onChangeBlock {
            changeBlock(value: self.cellInfo!.value!, cellInfo: self.cellInfo!)
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let disable = self.cellInfo?.disable {
            return !disable
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
