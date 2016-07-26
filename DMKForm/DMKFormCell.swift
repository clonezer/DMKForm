//
//  DMKFormCell.swift
//  DMKForm
//
//  Created by Peerasak Unsakon on 7/24/16.
//  Copyright © 2016 Peerasak Unsakon. All rights reserved.
//

import UIKit

class DMKFormCell: UITableViewCell {

    var tagName: String?
    
    var value: AnyObject? {
        didSet {
            self.update()
            if let block = self.onChangBlock {
                block(oldValue: nil, newValue: self.value, cell: self)
            }
        }
    }
    var title: String? {
        didSet {
            self.update()
        }
    }
    var detail: String? {
        didSet {
            self.update()
        }
    }
    
    var options: [AnyObject] = []
    var height: CGFloat = 55
    
    var cellDisable: Bool = false {
        didSet {
            self.disableCell()
        }
    }
    var cellHidden: Bool = false {
        didSet {
            if self.form?.form != nil {
                self.form!.reloadForm()
            }
        }
    }
    var actionBlock: DMKActionBlock?
    var onChangBlock: DMKOnChangeBlock?
    var form: DMKFormViewController?
    
    func update() {
    
    }
    
    func configCell() {
    
    }
    
    func disableCell() {
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    static func cellWithForm(formVC: DMKFormViewController, tagName: String, type: String, title: String?, value: AnyObject?) -> AnyObject {
        let cell = formVC.tableView.dequeueReusableCellWithIdentifier(type) as! DMKFormCell
        cell.form = formVC
        cell.tagName = tagName
        cell.value = value
        cell.title = title
        return cell
    }
    
    static func cellWithForm(formVC: DMKFormViewController, tagName: String, type: String, title: String?, value: AnyObject?, options: [AnyObject]) -> AnyObject {
        let cell = formVC.tableView.dequeueReusableCellWithIdentifier(type) as! DMKFormCell
        cell.form = formVC
        cell.options = options
        cell.configCell()
        
        cell.tagName = tagName
        cell.value = value
        cell.title = title
        
        return cell
    }

}