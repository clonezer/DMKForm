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
        let emailCell = DMKTextfieldCellInfo.create("Detail", title: "Email", value: "", formVC: self)
        let textViewCell = DMKTextfieldCellInfo.create("Detail", title: "Informations", value: "", formVC: self)
        let stepperCell = DMKStepperCellInfo.create("Stepped", title: "Stepper", value: 0, formVC: self)
        let dateCell = DMKDateCellInfo.create("Date", title: "Select Date", value: NSDate(), formVC: self)
        let newUnitButtonCell = DMKButtonCellInfo.create("UnitButton", title: "Hey Tap Me!", formVC: self)
        
        stepperCell.maximumValue = 5
        stepperCell.minimumValue = 1
        
        section.addCellInfo(segmentedCell)
        section.addCellInfo(emailCell)
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
