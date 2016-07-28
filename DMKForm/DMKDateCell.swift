//
//  DMKDateCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKDateCell: DMKFormCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func update() {
        
        guard let title = self.title, let value = self.value, let cellInfo = self.cellInfo else { return }
        
        self.cellInfo?.actionBlock = { cell in
            self.extendCell()
        }
        
        self.titleLabel.font = cellInfo.formViewController?.titleFont
        self.titleLabel.textColor = cellInfo.formViewController?.titleColor
        self.dateLabel.font = cellInfo.formViewController?.detailFont
        self.dateLabel.textColor = cellInfo.formViewController?.detailColor
        self.contentView.backgroundColor = cellInfo.formViewController?.cellColor
        
        self.titleLabel.text = title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.stringFromDate(value as! NSDate)
        self.dateLabel.text = dateString
    }
    
    override func disableCell() {
        self.height = 55
    }
    
    @IBAction func datePickerDidChanged(sender: AnyObject) {
        let datePicker = sender as! UIDatePicker
        self.value = datePicker.date
        self.cellInfo?.value = datePicker.date
        if let block = self.cellInfo?.onChangBlock {
            block(oldValue: nil, newValue: self.cellInfo?.value, cell: self)
        }
    }
    
    func extendCell() {
        if self.cellDisable == false {
            if self.height == 271 {
                self.height = 55
                self.cellInfo?.height = 55
            }else {
                self.height = 271
                self.cellInfo?.height = 271
            }
            self.cellInfo?.formViewController?.reloadForm()
        }
    }
}
