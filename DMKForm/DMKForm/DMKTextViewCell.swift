//
//  DMKTextViewCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/25/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit
import Validator

class DMKTextViewCellInfo: DMKFormCellInfo {
    static func create(tag: String, title: String, value: AnyObject?, formVC: DMKFormViewController) -> DMKTextViewCellInfo {
        return DMKTextViewCellInfo(tag: tag, title: title, type: String(DMKTextViewCell.self), value: value, options: nil, formVC: formVC)
    }
}

class DMKTextViewCell: DMKFormCell, UITextViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
    }
    
    override func configCell() {
        guard let formVC = self.cellInfo?.formViewController else { return }
        
        self.titleLabel.font = formVC.titleFont
        self.titleLabel.textColor = formVC.titleColor
        self.textView.font = formVC.detailFont
        self.textView.textColor = formVC.detailColor
        self.contentView.backgroundColor = formVC.cellColor
        
        self.update()
    }
    
    override func update() {
        guard let cellInfo = self.cellInfo else {
            self.titleLabel.text = "ERROR"
            self.textView.text = "ERROR"
            return
        }
        
        cellInfo.actionBlock = { cell in
            self.textView.becomeFirstResponder()
        }
        
        self.textView.validationRules = cellInfo.validationRuleSet
        self.textView.validateOnInputChange(true)
        self.textView.validationHandler = { result, sender in
            self.updateValidationState(result)
        }
        
        self.titleLabel.text = cellInfo.title
        self.textView.text = cellInfo.value as? String
        self.textView.editable = !cellInfo.disable
        
        if cellInfo.validationErrors?.isEmpty == false {
            let messages = cellInfo.validationErrors
            let message = messages!.joinWithSeparator(" and ")
            self.showError(message)
        }
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
    
    override func showError(message: String) {
        self.errorLabel.text = message
        self.errorView.hidden = false
    }
    
    func clearError() {
        self.errorLabel.text = ""
        self.errorView.hidden = true
        self.cellInfo?.validationErrors?.removeAll()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        guard let cellInfo = self.cellInfo else { return }
        cellInfo.value = textView.text
        if let block = cellInfo.onChangeBlock {
            block(value: textView.text, cellInfo: cellInfo)
        }
        self.update()
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        guard let cellInfo = self.cellInfo else { return false }
        return !cellInfo.disable
    }
    
}

extension UITextView: ValidatableInterfaceElement {
    
    public typealias InputType = String
    
    public var inputValue: String? { return text }
    
    public func validateOnInputChange(validationEnabled: Bool) {
        switch validationEnabled {
        case true: NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITextView.validateInput(_:)), name: UITextViewTextDidChangeNotification, object: self)
        case false: NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidChangeNotification, object: self)
        }
    }
    
    public func validateOnEditingEnd(validationEnabled: Bool) {
        switch validationEnabled {
        case true: NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITextView.validateInput(_:)), name: UITextViewTextDidEndEditingNotification, object: self)
        case false: NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidEndEditingNotification, object: self)
        }
    }
    
    @objc internal func validateInput(sender: NSNotification) {
        guard let sender = sender.object as? UITextView else {
            return
        }
        
        sender.validate()
    }
    
}