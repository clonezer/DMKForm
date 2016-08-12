//
//  DMKOptionsViewController.swift
//  HomeMadeStay
//
//  Created by Peerasak Unsakon on 8/1/16.
//  Copyright © 2016 Fire One One Co.,Ltd. All rights reserved.
//

import UIKit

typealias DMKOptionDidSelectedBlock = (option: String) -> ()

class DMKOptionsViewController: UITableViewController {
    
    var didSelectedBlock: DMKOptionDidSelectedBlock?
    var options: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "DMKOptionCell", bundle: nil), forCellReuseIdentifier: "DMKOptionCell")
    }

    func setupNavbarItemButton() {
        let navBarButtonItemAttribute = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: HSAppConstants.formTitleFont
        ]
        self.navigationController?.navigationBar.titleTextAttributes = navBarButtonItemAttribute
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(navBarButtonItemAttribute, forState: .Normal)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = options?.count else { return 0 }
        return numberOfRows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DMKOptionCell", forIndexPath: indexPath)

        if let options = self.options {
            cell.textLabel?.text = options[indexPath.row]
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let block = self.didSelectedBlock, let options = self.options {
            block(option: options[indexPath.row])
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
