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
    
    override func configCell() {
        guard let formVC = self.cellInfo?.formViewController, let options = self.cellInfo?.options else { return }
        
        self.titleLabel.font = formVC.titleFont
        self.titleLabel.textColor = formVC.titleColor
        self.segmentedControl.tintColor = formVC.tintColor
        self.contentView.backgroundColor = formVC.cellColor
        
        self.segmentedControl.removeAllSegments()
        for (index, option) in options.enumerate() {
            let name = option as! String
            self.segmentedControl.insertSegmentWithTitle(name, atIndex: index, animated: false)
        }
        
        self.update()
    }
    
    override func update() {
        guard let cellInfo = self.cellInfo, let value = self.cellInfo?.value, let options = self.cellInfo?.options else { return }
        self.titleLabel.text = cellInfo.title
        self.segmentedControl.selectedSegmentIndex = options.indexOf({$0 as! String == value as! String})!
        self.segmentedControl.enabled = !cellInfo.disable
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func segmentedValueChanged(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        guard let options = self.cellInfo?.options else { return }
        self.cellInfo?.value = options[segmentedControl.selectedSegmentIndex] as! String
        if let block = self.cellInfo!.onChangBlock {
            block(oldValue: nil, newValue: options[segmentedControl.selectedSegmentIndex] as! String, cell: self)
        }
    }
}
