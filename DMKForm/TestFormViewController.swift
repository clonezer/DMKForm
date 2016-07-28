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
        
        let section = DMKFormSectionInfo(tag: "General", title: "General", extendable: false)
        
        let segmentedCell = DMKFormCellInfo(tag: "Segmented", title: "Select", type: String(DMKSegmentedCell.self), value: "Type A", options: ["Type A", "Type B"], formVC: self)
        section.addCellInfo(segmentedCell)
        
        let nameCell = DMKFormCellInfo(tag: "Name", title: "Full Name", type: String(DMKTextfieldCell.self), value: "Peerasak Unsakon", options: nil, formVC: self)
        section.addCellInfo(nameCell)
        
        let cardCell = DMKFormCellInfo(tag: "IDCard", title: "ID Card", type: String(DMKTextfieldCell.self), value: "12345", options: nil, formVC: self)
        section.addCellInfo(cardCell)
        
        let stepperCell = DMKFormCellInfo(tag: "Stepper", title: "Stepper", type: String(DMKStepperCell.self), value: 0, options: nil, formVC: self)
        section.addCellInfo(stepperCell)
        
        let dateCell = DMKFormCellInfo(tag: "Date", title: "Datetime", type: String(DMKDateCell.self), value: NSDate(), options: nil, formVC: self)
        section.addCellInfo(dateCell)
        
        form.addSectionInfo(section)
        
        let section2 = DMKFormSectionInfo(tag: "Unit", title: "Unit", extendable: true)
        form.addSectionInfo(section2)
        let section3 = DMKFormSectionInfo(tag: "Button", title: "", extendable: false)
        let newUnitButtonCell = DMKFormCellInfo(tag: "UnitButton", title: "Add New Unit", type: String(DMKButtonCell.self), value: nil, options: nil, formVC: self)
        section3.addCellInfo(newUnitButtonCell)
        form.addSectionInfo(section3)
        
        
        self.form = form
        
        segmentedCell.onChangBlock = { (_, newValue, _) in
            cardCell.hidden = (newValue as! String == "Type B")
            self.reloadForm()
        }
        
        newUnitButtonCell.actionBlock = { _ in
            guard newUnitButtonCell.disable == false else { return }
            let unitCell = DMKFormCellInfo(tag: "", title: "Unit No.", type: String(DMKTextfieldCell.self), value: "", options: nil, formVC: self)
            unitCell.deletable = true
            section2.addCellInfo(unitCell)
            self.reloadForm()
        }
    }
    
    @IBAction func valueButtonTapped(sender: AnyObject) {
        debugPrint("==== values ====")
        debugPrint(self.form.getValues())
    }
    
    @IBAction func disableButtonTapped(sender: AnyObject) {
        self.form.disable = !self.form.disable
        self.disableButton.title = (self.form.disable == true ? "enable" : "disable")
        self.reloadForm()
    }
}
