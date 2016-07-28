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
        self.actionBlock = { cell in
            self.textView.becomeFirstResponder()
        }
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
        
        cellInfo.height = 85
        self.titleLabel.text = cellInfo.title
        self.textView.text = cellInfo.value as? String
    }
    
    override func disableCell() {
        guard let cellInfo = self.cellInfo else { return }
        self.textView.editable = !cellInfo.disable
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.cellInfo?.value = textView.text
        if let block = self.onChangBlock {
            block(oldValue: nil, newValue: textView.text, cell: self)
        }
        self.update()
    }
    
}