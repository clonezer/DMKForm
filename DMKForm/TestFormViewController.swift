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
        
        let unitKindCell = DMKFormCell.cellWithForm(self, tagName: "UnitKind", type: "DMKSegmentedCell", title: "Unit Kind", value: "Room", options: ["Room", "Bed"]) as! DMKSegmentedCell
        
        let unitTypeNameCell = DMKFormCell.cellWithForm(self, tagName: "UnitTypeName", type: "DMKTextfieldCell", title: "Unit Type Name", value: "") as! DMKTextfieldCell
        
        unitTypeNameCell.actionBlock = { cell in
            if unitTypeNameCell.cellDisable == true {
                //showPopup
            }else {
               unitTypeNameCell.textField.becomeFirstResponder()
            }
        }
        
        let unitDetailCell = DMKFormCell.cellWithForm(self, tagName: "UnitDetail", type: "DMKTextViewCell", title: "Unit Type Detail", value: "") as! DMKTextViewCell

        let dateCell = DMKFormCell.cellWithForm(self, tagName: "Date", type: "DMKDateCell", title: "Date", value: NSDate()) as! DMKDateCell
        
        let fullNameCell = DMKFormCell.cellWithForm(self, tagName: "FullName", type: "DMKTextfieldCell", title: "Full Name", value: "Peerasak Unsakon") as! DMKTextfieldCell

        unitKindCell.onChangBlock = { (oldValue, newValue, cell) in
            fullNameCell.cellHidden = (unitKindCell.value as! String == "Bed")
        }

        let section1 = DMKFormSection()
        section1.addCell(unitKindCell)
        section1.addCell(unitTypeNameCell)
        section1.addCell(unitDetailCell)
        section1.addCell(dateCell)
        section1.addCell(fullNameCell)
        form.addSection(section1)
        
        self.form = form
    }
    
    @IBAction func valueButtonTapped(sender: AnyObject) {
        debugPrint("values: \(self.form.getValues())")
    }
}
