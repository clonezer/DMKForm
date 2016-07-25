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
    
    var height: CGFloat = 55
    var cellDisable: Bool = false
    var cellHidden: Bool = false {
        didSet {
            self.form!.reloadForm()
        }
    }
    var actionBlock: DMKActionBlock?
    var onChangBlock: DMKOnChangeBlock?
    var form: DMKFormViewController?
    
    func update() {
    
    }
    
    func configCell() {
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    static func cellWithForm(formVC: DMKFormViewController, type: String) -> AnyObject {
        let cell = formVC.tableView.dequeueReusableCellWithIdentifier(type) as! DMKFormCell
        cell.form = formVC
        return cell
    }
    
    static func cellWithForm(formVC: DMKFormViewController, tagName: String, type: String, title: String?, value: AnyObject?) -> AnyObject {
        let cell = formVC.tableView.dequeueReusableCellWithIdentifier(type) as! DMKFormCell
        cell.form = formVC
        cell.tagName = tagName
        cell.value = value
        cell.title = title
        return cell
    }

}