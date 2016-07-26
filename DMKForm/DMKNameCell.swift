//
//  DMKNameCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKNameCell: DMKFormCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func update() {
        self.titleLabel.font = self.form?.titleFont
        self.titleLabel.textColor = self.form?.titleColor
        self.detailLabel.font = self.form?.detailFont
        self.detailLabel.textColor = self.form?.detailColor
        self.contentView.backgroundColor = self.form?.cellColor
        
        self.titleLabel.text = self.title
        self.detailLabel.text = self.value as? String
    }
}
