//
//  TestFormViewController.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class TestFormViewController: DMKFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let form = DMKForm()
        
        let nameCell = DMKFormCell.cellWithForm(self, tagName: "Name", type: "DMKNameCell", title: "First Name", value: "Peerasak") as! DMKNameCell
        
        let textFieldCell = DMKFormCell.cellWithForm(self, tagName: "EmailInput", type: "DMKTextfieldCell", title: "Input Email", value: "clonezer@gmail.com") as! DMKTextfieldCell
        
        let dateCell = DMKFormCell.cellWithForm(self, tagName: "Date", type: "DMKDateCell", title: "Date", value: NSDate()) as! DMKDateCell
        
        let mailCell = DMKFormCell.cellWithForm(self, tagName: "EmailInfo", type: "DMKNameCell", title: "Email Info", value: textFieldCell.value) as! DMKNameCell
        
        let checkInDate = DMKFormCell.cellWithForm(self, tagName: "CheckInDate", type: "DMKDateCell", title: "Check In Date", value: NSDate()) as! DMKDateCell
        
        let infoCell = DMKFormCell.cellWithForm(self, tagName: "InfoCell", type: "DMKNameCell", title: "Info", value: "Hello World!") as! DMKNameCell
        
        let fullNameCell = DMKFormCell.cellWithForm(self, tagName: "FullName", type: "DMKTextfieldCell", title: "Full Name", value: "Peerasak Unsakon") as! DMKTextfieldCell
        
        let textViewCell = DMKFormCell.cellWithForm(self, tagName: "TextView", type: "DMKTextViewCell", title: "Detail", value: "The quick brown fox jumps over the lazy dog") as! DMKTextViewCell
        

        textFieldCell.onChangBlock = { (oldValue, newValue, cell) in
            let mail = newValue as! String
            mailCell.value = mail
            textViewCell.cellHidden = (mail == "dadada")
        }
        
        dateCell.onChangBlock = { (oldValue, newValue, cell) in
            let date = newValue as! NSDate
            checkInDate.value = date
        }
        
        let section1 = DMKFormSection()
        section1.addCell(nameCell)
        section1.addCell(textFieldCell)
        section1.addCell(dateCell)
        form.addSection(section1)
        let section2 = DMKFormSection()
        section2.addCell(mailCell)
        section2.addCell(checkInDate)
        form.addSection(section2)
        let section3 = DMKFormSection()
        section3.addCell(infoCell)
        section3.addCell(fullNameCell)
        section3.addCell(textViewCell)
        form.addSection(section3)
        
        self.form = form
    }
}
