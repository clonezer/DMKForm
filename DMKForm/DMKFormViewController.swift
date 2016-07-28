//
//  DMKFormViewController.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

typealias DMKActionBlock = (cell: DMKFormCell?) -> Void
typealias DMKDidSelectBlock = (cell: DMKFormCellInfo?) -> Void
typealias DMKOnChangeBlock = (oldValue: AnyObject?, newValue: AnyObject?, cell: DMKFormCell) -> Void

class DMKForm {
    
    var title: String?
    var numberOfSections: Int = 0
    
    private var _sectionInfos: [DMKFormSectionInfo] = [] {
        didSet {
            self.numberOfSections = _sectionInfos.count
        }
    }
    
    var sectionInfos: [DMKFormSectionInfo] = []
    
    var disable: Bool = false {
        didSet {
            self.disableAllCell()
            self.reloadData()
        }
    }
    
    func addSectionInfo(sectionInfo: DMKFormSectionInfo) {
        sectionInfos.append(sectionInfo)
        _sectionInfos.append(sectionInfo)
    }
    
    func deleteInfo(section: Int, cellInfo: DMKFormCellInfo) {
        let sectionInfo = self.getSectionInfo(section)
        sectionInfo.deleteCellInfo(cellInfo)
    }
    
    func reloadData() {
        _sectionInfos.removeAll()
        for sectionInfo in sectionInfos {
            sectionInfo.reloadData()
            _sectionInfos.append(sectionInfo)
        }
    }
    
    func getSectionInfo(section: Int) -> DMKFormSectionInfo {
        return _sectionInfos[section]
    }
    
    func getValues() -> [String: AnyObject]? {
        var valueDict: [String: AnyObject] = Dictionary()

        for sectionInfo in _sectionInfos {
            var multivalues: [AnyObject] = []
            for cellInfo in sectionInfo._cellInfos {
                if sectionInfo.extendable == true {
                    multivalues.append(cellInfo.value!)
                }else {
                    valueDict[cellInfo.tag!] = cellInfo.value
                }
            }
            if sectionInfo.extendable == true {
                valueDict[sectionInfo.tag] = multivalues
            }
        }

        return valueDict
    }
    
    func disableAllCell() {
        for section in _sectionInfos {
            for cell in section._cellInfos {
                cell.disable = self.disable
            }
        }
    }
}

class DMKFormSectionInfo {
    var title: String?
    var tag: String!
    var footerText: String?
    var hidden: Bool = false
    var extendable: Bool = false
    
    var numberOfCells: Int = 0
    
    private var _cellInfos: [DMKFormCellInfo] = [] {
        didSet {
            self.numberOfCells = _cellInfos.count
        }
    }
    var cellInfos: [DMKFormCellInfo] = []
    
    init(tag: String, title: String, extendable: Bool) {
        self.tag = tag
        self.title = title
        self.extendable = extendable
    }
    
    func addCellInfo(cellInfo: DMKFormCellInfo) {
        cellInfos.append(cellInfo)
        if cellInfo.hidden == false {
            _cellInfos.append(cellInfo)
        }
    }
    
    func deleteCellInfo(cellInfo: DMKFormCellInfo) {
        guard
            let index = (cellInfos.indexOf{ $0 === cellInfo}),
            let _index = (_cellInfos.indexOf{ $0 === cellInfo})
        else { return }
        cellInfos.removeAtIndex(index)
        _cellInfos.removeAtIndex(_index)
    }
    
    func reloadData() {
        _cellInfos.removeAll()
        for cellInfo in self.cellInfos {
            if cellInfo.hidden == false {
                _cellInfos.append(cellInfo)
            }
        }
    }
    
    func getCellInfo(row: Int) -> DMKFormCellInfo {
        return _cellInfos[row]
    }
}

class DMKFormCellInfo {
    var tag: String?
    var title: String?
    var cellType: String?
    var hidden: Bool = false
    var disable: Bool = false
    var deletable: Bool = false
    var value: AnyObject?
    var options: [AnyObject]? = []
    var height: CGFloat = 55
    
    var formViewController: DMKFormViewController?
    var didSelectBlock: DMKDidSelectBlock?
    var actionBlock: DMKActionBlock?
    var onChangBlock: DMKOnChangeBlock?
    
    init(tag: String, title: String, type: String, value: AnyObject?, options: [AnyObject]?, formVC: DMKFormViewController) {
        self.tag = tag
        self.title = title
        self.cellType = type
        self.value = value
        self.options = options
        self.formViewController = formVC
    }
    
    func config() {
    
    }
    
    func update() {
    
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
        self.registerNibName(["DMKNameCell", "DMKTextfieldCell", "DMKDateCell", "DMKTextViewCell", "DMKSegmentedCell", "DMKStepperCell", "DMKNumberFieldCell", "DMKButtonCell"])
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
        return self.form.getSectionInfo(section).numberOfCells
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellInfo = self.form.getSectionInfo(indexPath.section).getCellInfo(indexPath.row)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellInfo.cellType!, forIndexPath: indexPath) as! DMKFormCell
        
        cell.options = cellInfo.options
        cell.cellInfo = cellInfo
        cell.title = cellInfo.title
        cell.value = cellInfo.value
        cell.form = cellInfo.formViewController
        cell.cellDisable = cellInfo.disable
        cell.height = cellInfo.height
        cell.configCell()
        cell.update()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.hideKeyboard()

        let cellInfo = self.form.getSectionInfo(indexPath.section).getCellInfo(indexPath.row)
        if let block = cellInfo.actionBlock {
            block(cell: nil)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.form.getSectionInfo(indexPath.section).getCellInfo(indexPath.row).height
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.form.getSectionInfo(section).title
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.form.getSectionInfo(section).footerText
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.form.getSectionInfo(indexPath.section).getCellInfo(indexPath.row).deletable

    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let cellInfo = self.form.getSectionInfo(indexPath.section).getCellInfo(indexPath.row)
            self.form.deleteInfo(indexPath.section, cellInfo: cellInfo)
            self.reloadForm()
        }
    }
    
    func reloadForm() {
        self.form.reloadData()
        self.tableView.reloadData()
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
}
