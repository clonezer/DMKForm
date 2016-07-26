//
//  DMKSegmentedCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/26/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKSegmentedCell: DMKFormCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func update() {
        self.titleLabel.font = self.form?.titleFont
        self.titleLabel.textColor = self.form?.titleColor
        self.segmentedControl.tintColor = self.form?.tintColor
        self.contentView.backgroundColor = self.form?.cellColor
        
        self.titleLabel.text = self.title
        self.segmentedControl.selectedSegmentIndex = options.indexOf({$0 as! String == self.value as! String})!
    }
    
    override func disableCell() {
        self.segmentedControl.enabled = !self.cellDisable
    }
    
    override func configCell() {
        super.configCell()
        self.segmentedControl.removeAllSegments()
        for (index, option) in self.options.enumerate() {
            let name = option as! String
            self.segmentedControl.insertSegmentWithTitle(name, atIndex: index, animated: false)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func segmentedValueChanged(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        self.value = self.options[segmentedControl.selectedSegmentIndex] as! String
        if let block = self.onChangBlock {
            block(oldValue: nil, newValue: self.value, cell: self)
        }
    }
}
