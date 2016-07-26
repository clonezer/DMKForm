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
        self.actionBlock = { cell in
            self.extendCell()
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func update() {
        super.update()
        self.titleLabel.text = self.title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.stringFromDate(self.value as! NSDate)
        self.dateLabel.text = dateString
    }
    
    override func disableCell() {
        self.height = 55
        self.form?.tableView.reloadData()
    }
    
    @IBAction func datePickerDidChanged(sender: AnyObject) {
        let datePicker = sender as! UIDatePicker
        self.value = datePicker.date
        if let block = self.onChangBlock {
            block(oldValue: nil, newValue: self.value, cell: self)
        }
    }
    
    func extendCell() {
        if self.cellDisable == false {
            if self.height == 271 {
                self.height = 55
            }else {
                self.height = 271
            }
            self.form?.tableView.reloadData()
        }
    }
}
