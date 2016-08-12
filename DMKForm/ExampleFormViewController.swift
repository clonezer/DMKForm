//
//  TestFormViewController.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit
import Validator

class ExampleFormViewController: DMKFormViewController {
    @IBOutlet weak var disableButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let form = DMKForm()
        
        let section = DMKFormSectionInfo(tag: "General", title: "General", extendable: false)
        let section1 = DMKFormSectionInfo(tag: "TextDetail", title: "Detail", extendable: false)
        let section2 = DMKFormSectionInfo(tag: "Unit", title: "Unit", extendable: true)
        let section3 = DMKFormSectionInfo(tag: "Button", title: "", extendable: false)
        
        let segmentedCell = DMKSegmentedCellInfo(tag: "Segmented", title: "Select", type: String(DMKSegmentedCell.self), value: "Type A", options: ["Type A", "Type B"], formVC: self)
        let emailCell = DMKTextfieldCellInfo(tag: "Email", title: "Email", type: String(DMKTextfieldCell.self), value: nil, options: nil, formVC: self)
        let emailInfoCell = DMKNameCellInfo(tag: "EmailInfo", title: "Email Info", type: String(DMKNameCell.self), value: emailCell.value, options: nil, formVC: self)
        let cardCell = DMKTextfieldCellInfo(tag: "IDCard", title: "ID Card", type: String(DMKTextfieldCell.self), value: "12345", options: nil, formVC: self)
        let textViewCell = DMKTextViewCellInfo(tag: "Detail", title: "Description", type: String(DMKTextViewCell.self), value: "", options: nil, formVC: self)
        let stepperCell = DMKStepperCellInfo(tag: "Stepper", title: "Stepper", type: String(DMKStepperCell.self), value: 0, options: nil, formVC: self)
        stepperCell.maximumValue = 5
        stepperCell.minimumValue = 1
        let dateCell = DMKDateCellInfo(tag: "Date", title: "Datetime", type: String(DMKDateCell.self), value: NSDate(), options: nil, formVC: self)
        let newUnitButtonCell = DMKButtonCellInfo(tag: "UnitButton", title: "Add New Unit", type: String(DMKButtonCell.self), value: nil, options: nil, formVC: self)
        
        section.addCellInfo(segmentedCell)
        section.addCellInfo(emailCell)
        section.addCellInfo(emailInfoCell)
        section.addCellInfo(cardCell)
        
        section1.addCellInfo(stepperCell)
        section1.addCellInfo(dateCell)
        section1.addCellInfo(textViewCell)
        
        section3.addCellInfo(newUnitButtonCell)
        
        form.addSectionInfo(section)
        
        form.addSectionInfo(section1)
        form.addSectionInfo(section2)
        form.addSectionInfo(section3)
        
        self.form = form
    }
    
    @IBAction func valueButtonTapped(sender: AnyObject) {
        if self.form.isValidate() {
            debugPrint("==== values ====")
            debugPrint(self.form.getValues())
        }else {
            debugPrint("==== form invalid ====")
            self.reloadForm()
        }
        
    }
    
    @IBAction func disableButtonTapped(sender: AnyObject) {
        self.form.disable = !self.form.disable
        self.disableButton.title = (self.form.disable == true ? "enable" : "disable")
        self.reloadForm()
    }
}
