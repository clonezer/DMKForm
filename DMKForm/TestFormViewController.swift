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
        
        let unitKindCell = DMKFormCell.cellWithForm(self, tagName: "UnitKind", type: "DMKSegmentedCell", title: "Unit Kind", value: "Per Bed", options: ["Per Room", "Per Bed"]) as! DMKSegmentedCell
        
        let unitTypeNameCell = DMKFormCell.cellWithForm(self, tagName: "UnitTypeName", type: "DMKTextfieldCell", title: "Unit Type Name", value: "") as! DMKTextfieldCell
            
        let unitDetailCell = DMKFormCell.cellWithForm(self, tagName: "UnitDetail", type: "DMKTextViewCell", title: "Unit Type Detail", value: "") as! DMKTextViewCell
        unitDetailCell.height = 100
        
        let guestNumberCell = DMKFormCell.cellWithForm(self, tagName: "GuestNumber", type: "DMKStepperCell", title: "Guest Number", value: 1) as! DMKStepperCell
        guestNumberCell.maximumValue = 10
        guestNumberCell.minimumValue = 1
        
        let extraNumberCell = DMKFormCell.cellWithForm(self, tagName: "ExtraNumber", type: "DMKStepperCell", title: "Extra Number", value: 0) as! DMKStepperCell
        extraNumberCell.maximumValue = 5
        extraNumberCell.minimumValue = 0
        
        let basePriceCell = DMKFormCell.cellWithForm(self, tagName: "BasePrice", type: "DMKTextfieldCell", title: "Base Price", value: "0") as! DMKTextfieldCell
        let extraPriceCell = DMKFormCell.cellWithForm(self, tagName: "ExtraPrice", type: "DMKTextfieldCell", title: "Extra Price", value: "0") as! DMKTextfieldCell
        
        extraNumberCell.cellHidden = (unitKindCell.value as! String == "Per Bed")
        extraPriceCell.cellHidden = (extraNumberCell.value as! Int) <= 0
        
        unitKindCell.onChangBlock = { (oldValue, newValue, cell) in
            extraNumberCell.cellHidden = (unitKindCell.value as! String == "Per Bed")
        }
        extraNumberCell.onChangBlock = { (oldValue, newValue, cell) in
            extraPriceCell.cellHidden = (newValue as! Int) <= 0
        }
        
        let section1 = DMKFormSection()
        section1.headerText = "infomation"
        section1.addCell(unitTypeNameCell)
        section1.addCell(unitDetailCell)
        form.addSection(section1)
        
        let section2 = DMKFormSection()
        section2.addCell(unitKindCell)
        form.addSection(section2)
        
        let section3 = DMKFormSection()
        section3.headerText = "capacity"
        section3.addCell(guestNumberCell)
        section3.addCell(extraNumberCell)
        form.addSection(section3)
        
        let section4 = DMKFormSection()
        section4.headerText = "pricing"
        section4.addCell(basePriceCell)
        section4.addCell(extraPriceCell)
        form.addSection(section4)
        
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
