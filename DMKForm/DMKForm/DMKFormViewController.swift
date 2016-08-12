//
//  DMKFormViewController.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit
import Validator

typealias DMKActionBlock = (cellInfo: DMKFormCellInfo) -> Void
typealias DMKOnChangeBlock = (value: AnyObject, cellInfo: DMKFormCellInfo) -> Void
typealias DMKOnDeleteBlock = (cellInfo: DMKFormCellInfo) -> Void
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
    
    func addSectionInfo(sectionInfo: DMKFormSectionInfo, index: Int) {
        sectionInfos.insert(sectionInfo, atIndex: index)
        _sectionInfos.insert(sectionInfo, atIndex: index)
    }
    
    func deleteInfo(section: Int, cellInfo: DMKFormCellInfo) {
        let sectionInfo = self.getSectionInfo(section)
        sectionInfo.deleteCellInfo(cellInfo)
    }
    
    func deleteSectionInfo(sectionInfo: DMKFormSectionInfo) {
        guard
            let _index = _sectionInfos.indexOf({ $0.tag == sectionInfo.tag }),
            let index = sectionInfos.indexOf({ $0.tag == sectionInfo.tag })else { return }
        
        _sectionInfos.removeAtIndex(_index)
        sectionInfos.removeAtIndex(index)
    }
    
    func reloadData() {
        _sectionInfos.removeAll()
        for sectionInfo in sectionInfos {
            sectionInfo.reloadData()
            _sectionInfos.append(sectionInfo)
        }
    }
    
    func getAllSectionInfos() -> [DMKFormSectionInfo] {
        return _sectionInfos
    }
    
    func getSectionInfo(section: Int) -> DMKFormSectionInfo {
        return _sectionInfos[section]
    }
    
    func getSectionInfo(tag: String) -> DMKFormSectionInfo? {
        guard
            let index = _sectionInfos.indexOf({ $0.tag == tag })
            else { return nil}
        return self.getSectionInfo(index)
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
    
    func hasChangedState() -> Bool {
        for section in self.getAllSectionInfos() {
            for cell in section.getAllCell()! {
                if cell.valueChanged == true {
                    return true
                }
            }
        }
        return false
    }
    
    func clearAllChangedState() {
        for section in sectionInfos {
            section.clearAllChangedCell()
        }
        
        for section in _sectionInfos {
            section.clearAllChangedCell()
        }
    }
    
    private func disableAllCell() {
        for section in _sectionInfos {
            for cell in section._cellInfos {
                cell.disable = self.disable
            }
        }
    }
    
    func isValidate() -> Bool {
        var isValid = true
        for section in _sectionInfos {
            for cell in section._cellInfos {
                if cell.validationRuleSet != nil {
                    let value = (cell.value == nil ? "" : "\(cell.value!)")
                    let result = Validator.validate(input: value, rules: cell.validationRuleSet!)
                    switch result {
                    case .Invalid(let failures):
                        cell.validate = false
                        cell.validationErrors = failures.map { $0.message }
                        isValid = false
                    case .Valid:
                        cell.validate = true
                        cell.validationErrors?.removeAll()
                    }
                }else {
                    cell.validate = true
                }
            }
        }
        return isValid
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
    
    func getAllCell() -> [DMKFormCellInfo]? {
        return _cellInfos
    }
    
    func addCellInfo(cellInfo: DMKFormCellInfo) {
        cellInfos.append(cellInfo)
        if cellInfo.hidden == false {
            _cellInfos.append(cellInfo)
        }
    }
    
    func deleteAllCellInfo() {
        cellInfos.removeAll()
        _cellInfos.removeAll()
    }
    
    func deleteLastCellInfo() {
        cellInfos.removeLast()
        _cellInfos.removeLast()
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
    
    func getCellInfo(tag: String) -> DMKFormCellInfo? {
        guard
            let index = cellInfos.indexOf({ $0.tag == tag })
            else { return nil}
        return cellInfos[index]
    }
    
    func clearAllChangedCell() {
        for cell in cellInfos {
            cell.valueChanged = false
        }
        
        for cell in _cellInfos {
            cell.valueChanged = false
        }
    }
}

class DMKFormCellInfo {
    var tag: String?
    var title: String?
    var cellType: String?
    var value: AnyObject? {
        didSet {
            if let nv = self.value as? String, ov = oldValue as? String {
                if nv != ov {self.valueChanged = true}
            }
            else if let nv = self.value as? Double, ov = oldValue as? Double {
                if nv != ov {self.valueChanged = true}
            }
            else if let nv = self.value as? Float, ov = oldValue as? Float {
                if nv != ov {self.valueChanged = true}
            }
            else if let nv = self.value as? Int, ov = oldValue as? Int {
                if nv != ov {self.valueChanged = true}
            }
            else if let nv = self.value as? Bool, ov = oldValue as? Bool {
                if nv != ov {self.valueChanged = true}
            }
        }
    }
    
    var options: [AnyObject]? = []
    var height: CGFloat = 55
    var hidden: Bool = false
    var disable: Bool = false
    var deletable: Bool = false
    var valueChanged: Bool = false
    var validate: Bool = true
    var validationRuleSet: ValidationRuleSet<String>? = ValidationRuleSet<String>()
    var validationErrors: [String]?
    var otherData: AnyObject?
    
    var formViewController: DMKFormViewController?
    var actionBlock: DMKActionBlock?
    var onChangeBlock: DMKOnChangeBlock?
    var onDeleteBlock: DMKOnDeleteBlock?

    
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
    
    static func create(tag: String, title: String, type: String, value: AnyObject?, options: [AnyObject]?, formVC: DMKFormViewController) -> AnyObject {
        return DMKFormCellInfo(tag: tag, title: title, type: type, value: value, options: options, formVC: formVC)
    }
}

class DMKFormViewController: UITableViewController {

    var form: DMKForm!
    
    var headerFont: UIFont = UIFont.boldSystemFontOfSize(20)
    var headerColor: UIColor = UIColor.darkGrayColor()
    var titleFont: UIFont = UIFont.boldSystemFontOfSize(15)
    var detailFont: UIFont = UIFont.systemFontOfSize(15)
    var tintColor: UIColor = UIColor(red: 215/255, green: 35/255, blue: 35/255, alpha: 1.0)
    var titleColor: UIColor = UIColor(red: 48/255, green: 56/255, blue: 65/255, alpha: 1.0)
    var detailColor: UIColor = UIColor(red: 58/255, green: 71/255, blue: 80/255, alpha: 1.0)
    var cellColor: UIColor = UIColor.whiteColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibName([
            "DMKNameCell",
            "DMKTextfieldCell",
            "DMKDateCell",
            "DMKTextViewCell",
            "DMKSegmentedCell",
            "DMKStepperCell",
            "DMKNumberFieldCell",
            "DMKButtonCell"
            ])
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
        
        cell.cellInfo = cellInfo
        cell.configCell()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.hideKeyboard()

        let cellInfo = self.form.getSectionInfo(indexPath.section).getCellInfo(indexPath.row)
        if let block = cellInfo.actionBlock {
            block(cellInfo: cellInfo)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellInfo = self.form.getSectionInfo(indexPath.section).getCellInfo(indexPath.row)
        return cellInfo.height
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.form.getSectionInfo(section).title
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.form.getSectionInfo(section).footerText
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.form.disable == true {
            return false
        }
        return self.form.getSectionInfo(indexPath.section).getCellInfo(indexPath.row).deletable
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let cellInfo = self.form.getSectionInfo(indexPath.section).getCellInfo(indexPath.row)
            if let block = cellInfo.onDeleteBlock {
                block(cellInfo: cellInfo)
            }
            //If you want to delete cellInfo
            //self.form.deleteInfo(indexPath.section, cellInfo: cellInfo)
            //self.reloadForm()
        }
    }
    
    func reloadForm() {
        self.form.clearAllChangedState()
        self.form.reloadData()
        self.tableView.reloadData()
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
}
