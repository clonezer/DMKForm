//
//  TestFormViewController.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit
import SwiftValidators

class TestFormViewController: DMKFormViewController {
    @IBOutlet weak var disableButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let form = DMKForm()
        
        let section = DMKFormSectionInfo(tag: "General", title: "General", extendable: false)
        let segmentedCell = DMKSegmentedCellInfo(tag: "Segmented", title: "Select", type: String(DMKSegmentedCell.self), value: "Type A", options: ["Type A", "Type B"], formVC: self)
        section.addCellInfo(segmentedCell)
        
        let emailCell = DMKTextfieldCellInfo(tag: "Email", title: "Email", type: String(DMKTextfieldCell.self), value: nil, options: nil, formVC: self)
        section.addCellInfo(emailCell)
        
        let emailInfoCell = DMKNameCellInfo(tag: "EmailInfo", title: "Email Info", type: String(DMKNameCell.self), value: emailCell.value, options: nil, formVC: self)
        section.addCellInfo(emailInfoCell)
        let cardCell = DMKTextfieldCellInfo(tag: "IDCard", title: "ID Card", type: String(DMKTextfieldCell.self), value: "12345", options: nil, formVC: self)
        section.addCellInfo(cardCell)
        form.addSectionInfo(section)
        
        let section1 = DMKFormSectionInfo(tag: "TextDetail", title: "Detail", extendable: false)
        let textViewCell = DMKTextViewCellInfo(tag: "Detail", title: "Description", type: String(DMKTextViewCell.self), value: "", options: nil, formVC: self)
        section1.addCellInfo(textViewCell)
        let stepperCell = DMKStepperCellInfo(tag: "Stepper", title: "Stepper", type: String(DMKStepperCell.self), value: 0, options: nil, formVC: self)
        stepperCell.maximumValue = 5
        stepperCell.minimumValue = 1
        section1.addCellInfo(stepperCell)
        let dateCell = DMKDateCellInfo(tag: "Date", title: "Datetime", type: String(DMKDateCell.self), value: NSDate(), options: nil, formVC: self)
        section1.addCellInfo(dateCell)
        form.addSectionInfo(section1)
        
        let section2 = DMKFormSectionInfo(tag: "Unit", title: "Unit", extendable: true)
        form.addSectionInfo(section2)
        
        let section3 = DMKFormSectionInfo(tag: "Button", title: "", extendable: false)
        let newUnitButtonCell = DMKButtonCellInfo(tag: "UnitButton", title: "Add New Unit", type: String(DMKButtonCell.self), value: nil, options: nil, formVC: self)
        section3.addCellInfo(newUnitButtonCell)
        
        form.addSectionInfo(section3)
        
        self.form = form
        
        emailCell.validatorBlock = { cellInfo in
            if let value = cellInfo.value as? String {
                return Validator.isEmail(value)
            }
            return false
        }
        emailCell.onChangBlock = { value in
            emailInfoCell.value = value as? String
            self.reloadForm()
        }
        
        segmentedCell.onChangBlock = { value in
            cardCell.hidden = (value as! String == "Type B")
            self.reloadForm()
        }
        
        newUnitButtonCell.actionBlock = { _ in
            guard newUnitButtonCell.disable == false else { return }
            let unitCell = DMKTextfieldCellInfo(tag: "", title: "Unit No.", type: String(DMKTextfieldCell.self), value: "", options: nil, formVC: self)
            unitCell.placeholder = "Room number"
            unitCell.deletable = true
            section2.addCellInfo(unitCell)
            self.reloadForm()
        }
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
