//
//  DMKDateCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKDateCellInfo: DMKFormCellInfo {

    var minimumDate: NSDate?
    var maximumDate: NSDate?
    
    override init(tag: String, title: String, type: String, value: AnyObject?, options: [AnyObject]?, formVC: DMKFormViewController) {
        super.init(tag: tag, title: title, type: type, value: value, options: options, formVC: formVC)
    }
}

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
    
    override func configCell() {
        guard let cellInfo = self.cellInfo, let formVC = self.cellInfo?.formViewController else { return }
        
        cellInfo.actionBlock = { cell in
            self.extendCell()
        }
        
        self.titleLabel.font = formVC.titleFont
        self.titleLabel.textColor = formVC.titleColor
        self.dateLabel.font = formVC.detailFont
        self.dateLabel.textColor = formVC.detailColor
        self.contentView.backgroundColor = formVC.cellColor
        
        self.update()
    }
    
    override func update() {
        guard let cellInfo = self.cellInfo as? DMKDateCellInfo else { return }
        self.titleLabel.text = cellInfo.title
        self.datePicker.minimumDate = cellInfo.minimumDate
        self.datePicker.maximumDate = cellInfo.maximumDate
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.stringFromDate(cellInfo.value as! NSDate)
        self.dateLabel.text = dateString
        
        if cellInfo.disable == true {
            cellInfo.height = 55
        }
    }
    
    @IBAction func datePickerDidChanged(sender: AnyObject) {
        let datePicker = sender as! UIDatePicker
        self.cellInfo?.value = datePicker.date
        if let block = self.cellInfo?.onChangBlock {
            block(value: datePicker.date)
        }
        self.update()
    }
    
    func extendCell() {
        guard let cellInfo = self.cellInfo, let disable = self.cellInfo?.disable else { return }
        if disable == false {
            if cellInfo.height == 271 {
                cellInfo.height = 55
            }else {
                cellInfo.height = 271
            }
            cellInfo.formViewController?.reloadForm()
        }
    }
}
