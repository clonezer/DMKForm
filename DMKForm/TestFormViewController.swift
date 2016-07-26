//
//  TestFormViewController.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class TestFormViewController: DMKFormViewController {
    @IBOutlet weak var disableButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let form = DMKForm()
        
        let unitKindCell = DMKFormCell.cellWithForm(self, tagName: "UnitKind", type: "DMKSegmentedCell", title: "Unit Kind", value: "Room", options: ["Room", "Bed"]) as! DMKSegmentedCell
        
        let unitTypeNameCell = DMKFormCell.cellWithForm(self, tagName: "UnitTypeName", type: "DMKTextfieldCell", title: "Unit Type Name", value: "") as! DMKTextfieldCell
            
        let unitDetailCell = DMKFormCell.cellWithForm(self, tagName: "UnitDetail", type: "DMKTextViewCell", title: "Unit Type Detail", value: "") as! DMKTextViewCell

        let dateCell = DMKFormCell.cellWithForm(self, tagName: "Date", type: "DMKDateCell", title: "Date", value: NSDate()) as! DMKDateCell
        
        let fullNameCell = DMKFormCell.cellWithForm(self, tagName: "FullName", type: "DMKTextfieldCell", title: "Full Name", value: "Peerasak Unsakon") as! DMKTextfieldCell
        
        let guestNumberCell = DMKFormCell.cellWithForm(self, tagName: "GuestNumber", type: "DMKStepperCell", title: "Guest Number", value: 1) as! DMKStepperCell
        guestNumberCell.maximumValue = 10
        guestNumberCell.minimumValue = 1
        
        let extraNumberCell = DMKFormCell.cellWithForm(self, tagName: "ExtraNumber", type: "DMKStepperCell", title: "Extra Number", value: 0) as! DMKStepperCell
        extraNumberCell.maximumValue = 5
        extraNumberCell.minimumValue = 0

        unitKindCell.onChangBlock = { (oldValue, newValue, cell) in
            extraNumberCell.cellHidden = (unitKindCell.value as! String == "Bed")
        }
        
        let section1 = DMKFormSection()
        section1.headerText = "general"
        section1.addCell(unitKindCell)
        section1.addCell(unitTypeNameCell)
        section1.addCell(unitDetailCell)
        section1.addCell(dateCell)
        section1.addCell(fullNameCell)
        form.addSection(section1)
        
        let section2 = DMKFormSection()
        section2.headerText = "guest number"
        section2.addCell(guestNumberCell)
        section2.addCell(extraNumberCell)
        form.addSection(section2)
        
        self.form = form
    }
    
    @IBAction func valueButtonTapped(sender: AnyObject) {
        debugPrint("values: \(self.form.getValues())")
    }
    
    @IBAction func disableButtonTapped(sender: AnyObject) {
        self.form.disable = !self.form.disable
        self.disableButton.title = (self.form.disable == true ? "enable" : "disable")
        self.reloadForm()
    }
}
