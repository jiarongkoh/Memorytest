//
//  ViewController.swift
//  Memorytest
//
//  Created by Koh Jia Rong on 2019/5/27.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController, FileSizeDelegate {
   
    let textArray = [["Save using Concurrent Queue",
                      "Save using Concurrent Queue with Autoreleasepool"],
                     ["Save using Serial Queue",
                      "Save using Serial Queue with Autoreleasepool"],
                     ["Global array", "Local array"],
                     ["Managed Realm", "Unmanaged Realm"],
                     ["EmailDB", "try Realm", "With release object"],
    ]
    
    let titleArray = ["Concurrent Queue",
                      "Serial Queue",
                      "Append to Array",
                      "Append with Managed & Unmanaged Realm",
                      "EmailDB VS Realm",
                      ]
    
    let footerArray = ["NOTE: Delete DB first, and tap on row",
                       "NOTE: Delete DB first, and tap on row",
                       "NOTE: Delete DB first, setup DB, then tap on row",
                       "NOTE: Delete DB first, setup DB, then tap on row",
                       "NOTE: Delete DB first, setup DB, then tap on row",]
    
    var globalEmails = [Email]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViews()
    }
    
    //MARK:- Setup
    
    func setupViews() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete DB", style: .plain, target: self, action: #selector(deleteDB))
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Setup DB", style: .plain, target: self, action: #selector(setupDB)),
           
        ]
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func setupDB() {
        for i in 0..<50 {
            let email = Email()
            email.bodyText = "\(i) Text"
            email.subject = "\(i) Subject"
            email.timestamp = Date().timeIntervalSince1970
            
            do {
                let realm = try Realm()
                realm.refresh()
                
                try realm.write {
                    realm.add(email)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        FileMonitorManager.sharedInst.register()
        FileMonitorManager.sharedInst.fileSizeDelegate = self
    }
    
    @objc func deleteDB() {
        autoreleasepool {
            do {
                let realm = try Realm()
                realm.invalidate()
                
                let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
                let realmURLs = [
                    realmURL,
                    realmURL.appendingPathExtension("lock"),
                    realmURL.appendingPathExtension("note"),
                    realmURL.appendingPathExtension("management")
                ]
                for URL in realmURLs {
                    do {
                        try FileManager.default.removeItem(at: URL)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                self.title = nil
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    //MARK:- FileSizeUpdate Delegate
    
    func fileSizeDidUpdate(size: String) {
        DispatchQueue.main.async {
            self.title = "\(size)M"
        }
    }
    
    //MARK:- Try Realm
    
    ///DB will bloat
    func queryByDBSync() {
        let firstQueue = DispatchQueue.init(label: "com.test.concurrent", qos: .userInteractive, attributes: .concurrent)
        let secondQueue = DispatchQueue.init(label: "com.test.concurrent2", qos: .userInteractive, attributes: .concurrent)
        
        for i in 0..<10 {
            //Read and Write
            firstQueue.async {
                for j in 0..<500 {
                    EmailDAL.writeToDBSync({ (db) in
                        let sub = "\(i) Text"
                        
                        if let email = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
                            let contact = Contact()
                            contact.id = UUID().uuidString
                            contact.name = "\(j) name"

                            db.write {
                                email.contacts.append(contact)
                            }
                        }
                    })
                }
            }
            
            //Read and append to global array, ie globalEmails
            secondQueue.async {
                EmailDAL.writeToDBSync({ (db) in
                    let sub = "\(i) Text"

                    if let email = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
                        //Append to global email array
                        self.globalEmails.append(email)
                        print(self.globalEmails.count)
                    }
                })
            }
        }
    }
    
    ///DB will bloat
    func queryByTryRealm() {
        let firstQueue = DispatchQueue.init(label: "com.test.concurrent", qos: .userInteractive, attributes: .concurrent)
        let secondQueue = DispatchQueue.init(label: "com.test.concurrent2", qos: .userInteractive, attributes: .concurrent)
        
        for i in 0..<10 {
            //Read and Write
            firstQueue.async {
                for j in 0..<500 {

                    EmailDAL.writeToDBSync2({ (realm) in
                        do {
                            let sub = "\(i) Text"
                            
                            if let email = realm.objects(Email.self).filter("bodyText == %@", sub).first {
                                let contact = Contact()
                                contact.id = UUID().uuidString
                                contact.name = "\(j) name"

                                try realm.write {
                                    email.contacts.append(contact)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                }

            }
            
            //Read and append to global array, ie globalEmails
            secondQueue.async {
                EmailDAL.writeToDBSync2({ (realm) in
                    let sub = "\(i) Text"

                    if let email = realm.objects(Email.self).filter("bodyText == %@", sub).first {
                        //Append to global email array
                        self.globalEmails.append(email)
                    }
                })
            }
        }
    }
    
    ///DB will bloat
    func releaseRealmObject() {
        let firstQueue = DispatchQueue.init(label: "com.test.concurrent", qos: .userInteractive, attributes: .concurrent)
        let secondQueue = DispatchQueue.init(label: "com.test.concurrent2", qos: .userInteractive, attributes: .concurrent)
        
        for i in 0..<10 {
            //Read and Write
            firstQueue.async {
                for j in 0..<500 {
                    EmailDAL.writeToDBSync({ (db) in
                        let sub = "\(i) Text"
                        
                        if let email = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
                            let contact = Contact()
                            contact.id = UUID().uuidString
                            contact.name = "\(j) name"
                            
                            db.write {
                                email.contacts.append(contact)
                            }
                        }
                    })
                }
            }
            
            //Read and append to global array, ie globalEmails
            secondQueue.async {
                EmailDAL.writeToDBSync({ (db) in
                    let sub = "\(i) Text"
                    
                    var email: Email?
                    
                    autoreleasepool {
                        if let realmEmail = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
                            email = Email(value: realmEmail)
                        }
                    }
                    
                    if let email = email {
                        //Append to global email array
                        self.globalEmails.append(email)
                        print(self.globalEmails.count)
                    }
                })
            }
        }
    }

}

