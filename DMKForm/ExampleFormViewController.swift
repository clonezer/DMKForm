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
        
        let section0 = DMKFormSectionInfo(tag: "General", title: "General", extendable: false)
        let section1 = DMKFormSectionInfo(tag: "TextDetail", title: "Detail", extendable: false)
        let section2 = DMKFormSectionInfo(tag: "Unit", title: "Unit", extendable: true)
        let section3 = DMKFormSectionInfo(tag: "Button", title: "", extendable: false)
        
        let segmentedCell = DMKSegmentedCellInfo.create("Segmented", title: "Select", value: "Type A", options: ["Type A", "Type B"], formVC: self)
        let emailCell = DMKTextfieldCellInfo.create("Detail", title: "Email", value: "", formVC: self)
        let textViewCell = DMKTextfieldCellInfo.create("Detail", title: "Informations", value: "", formVC: self)
        let stepperCell = DMKStepperCellInfo.create("Stepped", title: "Stepper", value: 0, formVC: self)
        let optionCell = DMKPushCellInfo.create("Optional", title: "Option", value: nil, formVC: self)
        let dateCell = DMKDateCellInfo.create("Date", title: "Select Date", value: NSDate(), formVC: self)
        let newUnitButtonCell = DMKButtonCellInfo.create("UnitButton", title: "Hey Tap Me!", formVC: self)
        
        stepperCell.maximumValue = 5
        stepperCell.minimumValue = 0
        
        section0.addCellInfo(segmentedCell)
        section0.addCellInfo(emailCell)
        section1.addCellInfo(stepperCell)
        section1.addCellInfo(dateCell)
        section1.addCellInfo(textViewCell)
        section1.addCellInfo(optionCell)
        section3.addCellInfo(newUnitButtonCell)
        
        form.addSectionInfo(section0)
        form.addSectionInfo(section1)
        form.addSectionInfo(section2)
        form.addSectionInfo(section3)
        
        self.form = form
        
        optionCell.actionBlock = { _ in
            let optionVC = DMKOptionsViewController()
            optionVC.optionTitleFont = self.titleFont
            optionVC.options = ["Apple", "Pinenapple", "Mango", "Peach"]
            optionVC.didSelectedBlock = { selectedValue in
                optionCell.value = selectedValue
                self.reloadForm()
            }
            self.navigationController?.pushViewController(optionVC, animated: true)
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
