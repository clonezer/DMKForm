//
//  DMKTextfieldCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit
import Validator

class DMKTextfieldCellInfo: DMKFormCellInfo {
    
    var placeholder: String?
    
    static func create(tag: String, title: String, value: AnyObject?, formVC: DMKFormViewController) -> DMKTextfieldCellInfo {
        return DMKTextfieldCellInfo(tag: tag, title: title, type: String(DMKTextfieldCell.self), value: value, options: nil, formVC: formVC)
    }

}

class DMKTextfieldCell: DMKFormCell {

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
        guard let cellInfo = self.cellInfo as? DMKTextfieldCellInfo else { return }

        self.textField.validationRules = cellInfo.validationRuleSet
        self.textField.validateOnInputChange(true)
        self.textField.validationHandler = { result, sender in self.updateValidationState(result) }
        
        self.titleLabel.text = cellInfo.title
        self.textField.placeholder = cellInfo.placeholder
        self.textField.text = cellInfo.value as? String
        self.textField.enabled = !cellInfo.disable
        
        if cellInfo.validationErrors?.isEmpty == false {
            let messages = cellInfo.validationErrors
            let message = messages!.joinWithSeparator(" and ")
            self.showError(message)
        }
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
            let message = messages.joinWithSeparator(" และ ")
            self.showError(message)
        }
    }
}

extension DMKTextfieldCell: UITextFieldDelegate {

    func textFieldDidEndEditing(textField: UITextField) {
        guard let cellInfo = self.cellInfo else { return }
        cellInfo.value = textField.text
        if let changeBlock = cellInfo.onChangeBlock {
            changeBlock(value: textField.text!, cellInfo: cellInfo)
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {        
        if let disable = self.cellInfo?.disable {
            return !disable
        }

        guard
            let formVC = self.cellInfo?.formViewController
            where formVC.presentedViewController == nil
            else { return false }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
