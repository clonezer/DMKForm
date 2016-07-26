//
//  DMKFormViewController.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

typealias DMKActionBlock = (cell: DMKFormCell) -> Void
typealias DMKOnChangeBlock = (oldValue: AnyObject?, newValue: AnyObject?, cell: DMKFormCell) -> Void

class DMKForm {
    
    var disable: Bool = false {
        didSet {
            self.disableAllCell()
            self.reloadData()
        }
    }
    
    var title: String?
    var numberOfSections: Int = 0
    
    private var realSections: [DMKFormSection] = [] {
        didSet {
            numberOfSections = realSections.count
        }
    }
    
    private var sections: [DMKFormSection] = []
    
    func addSection(section: DMKFormSection) {
        sections.append(section)
        realSections.append(section)
    }
    
    func getSection(section: Int) -> DMKFormSection {
        return realSections[section]
    }
    
    func reloadData() {
        realSections.removeAll()
        for section in sections {
            section.reloadData()
            realSections.append(section)
        }
    }
    
    func getValues() -> [String: AnyObject]? {
        var valueDict: [String: AnyObject] = Dictionary()
        
        for section in realSections {
            for cell in section.realCells {
                valueDict[cell.tagName!] = cell.value
            }
        }
        
        return valueDict
    }
    
    func disableAllCell() {
        for section in sections {
            for cell in section.cells {
                cell.cellDisable = self.disable
            }
        }
    }
}

class DMKFormSection {
    var title: String?
    var headerText: String?
    var footerText: String?
    
    var numberOfRows: Int = 0
    
    private var realCells: [DMKFormCell] = [] {
        didSet {
            self.numberOfRows = realCells.count
        }
    }
    private var cells: [DMKFormCell] = []
    
    func addCell(cell: DMKFormCell) {
        cells.append(cell)
        if cell.cellHidden == false {
            realCells.append(cell)
        }
    }
    
    func getCell(indexPath: NSIndexPath) -> DMKFormCell {
        return realCells[indexPath.row]
    }
    
    func reloadData() {
        realCells.removeAll()
        for cell in cells {
            if cell.cellHidden == false {
                realCells.append(cell)
            }
        }
    }
}

class DMKFormViewController: UITableViewController {

    var form: DMKForm!
    
    var titleFont: UIFont = UIFont.boldSystemFontOfSize(15)
    var detailFont: UIFont = UIFont.systemFontOfSize(15)
    var tintColor: UIColor = UIColor(red: 215/255, green: 35/255, blue: 35/255, alpha: 1.0)
    var titleColor: UIColor = UIColor(red: 48/255, green: 56/255, blue: 65/255, alpha: 1.0)
    var detailColor: UIColor = UIColor(red: 58/255, green: 71/255, blue: 80/255, alpha: 1.0)
    var cellColor: UIColor = UIColor.whiteColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNibName(["DMKNameCell", "DMKTextfieldCell", "DMKDateCell", "DMKTextViewCell", "DMKSegmentedCell", "DMKStepperCell"])
    }
    
    func registerNibName(nibNames: [String]) {
        for name in nibNames {
            self.tableView.registerNib(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.form.numberOfSections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.getSection(section).numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return self.form.getSection(indexPath.section).getCell(indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.hideKeyboard()
        
        let cell = self.form.getSection(indexPath.section).getCell(indexPath) 
        if let block = cell.actionBlock {
            block(cell: cell)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.form.getSection(indexPath.section).getCell(indexPath).height
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.form.getSection(section).headerText
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.form.getSection(section).footerText
    }
    
    func reloadForm() {
        self.form.reloadData()
        self.tableView.reloadData()
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
}
