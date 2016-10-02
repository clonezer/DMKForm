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
    var options: [String] = [String]()
    var filteredOptions: [String] = [String]()
    var optionTitleFont: UIFont = UIFont.systemFontOfSize(24)
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "DMKOptionCell", bundle: nil), forCellReuseIdentifier: "DMKOptionCell")
        self.setupSearchBar()
    }

    private func setupSearchBar() {
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.searchController.searchBar.barTintColor = self.tableView.backgroundColor
        self.searchController.searchBar.tintColor = .redColor()
        self.searchController.searchBar.searchBarStyle = .Minimal
        self.searchController.searchBar.barStyle = .Default
    }
    
    private func setupNavbarItemButton() {
        let navBarButtonItemAttribute = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: self.optionTitleFont
        ]
        self.navigationController?.navigationBar.titleTextAttributes = navBarButtonItemAttribute
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(navBarButtonItemAttribute, forState: .Normal)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching() {
            return filteredOptions.count
        }
        return options.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DMKOptionCell", forIndexPath: indexPath)
        
        var option: String = ""
        if self.isSearching() {
            option = self.filteredOptions[indexPath.row]
        } else {
            option = self.options[indexPath.row]
        }
        cell.textLabel?.text = option
        cell.textLabel?.font = self.optionTitleFont
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let block = self.didSelectedBlock {
            if self.isSearching() {
                block(option: self.filteredOptions[indexPath.row])
            } else {
                block(option: self.options[indexPath.row])
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}


extension DMKOptionsViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.filterContentForSearchText(text)
    }
    
    private func isSearching() -> Bool {
        return self.searchController.active && self.searchController.searchBar.text != ""
    }
    
    private func filterContentForSearchText(searchText: String) {
        self.filteredOptions = self.options.filter { option in
            return option.lowercaseString.containsString(searchText.lowercaseString)
        }
        self.tableView.reloadData()
    }
}