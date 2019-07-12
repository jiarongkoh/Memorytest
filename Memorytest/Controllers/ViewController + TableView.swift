//
//  ViewController + TableView.swift
//  Memorytest
//
//  Created by Koh Jia Rong on 2019/7/12.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import UIKit

extension ViewController {
    
    //MARK:- TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleArray[section]
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footerArray[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = textArray[indexPath.section][indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                saveInConcurrentQueue()
            } else {
                saveInConcurrentQueueWithAutorelease()
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                saveinSerialQueue()
            } else {
                saveinSerialQueueWithAutorelease()
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                appendToGlobalArray()
            } else {
                appendToLocalArray()
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                appendWithManaged()
            } else {
                appendWithUnmanaged()
            }
        }
        else if indexPath.section == 4 {
            if indexPath.row == 0 {
                queryByDBSync()
            } else if indexPath.row == 1 {
                queryByTryRealm()
            } else {
                releaseRealmObject()
            }
        }
    }
}
