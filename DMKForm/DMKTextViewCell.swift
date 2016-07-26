//
//  DMKTextViewCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/25/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKTextViewCell: DMKFormCell, UITextViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
        self.height = 200
        self.actionBlock = { cell in
            self.textView.becomeFirstResponder()
        }
    }
    
    override func update() {
        self.titleLabel.font = self.form?.titleFont
        self.titleLabel.textColor = self.form?.titleColor
        self.textView.font = self.form?.detailFont
        self.textView.textColor = self.form?.detailColor
        self.contentView.backgroundColor = self.form?.cellColor
        
        
        self.titleLabel.text = self.title
        self.textView.text = self.value as? String
    }
    
    override func disableCell() {
        self.textView.editable = !cellDisable
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.value = textView.text
        if let block = self.onChangBlock {
            block(oldValue: nil, newValue: self.value, cell: self)
        }
    }
    
}