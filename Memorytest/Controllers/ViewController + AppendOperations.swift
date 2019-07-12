//
//  ViewController + AppendOperations.swift
//  Memorytest
//
//  Created by Koh Jia Rong on 2019/7/12.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import UIKit
import RealmSwift

extension ViewController {
    
    //MARK:- Append to Array
        
    /**
     Append to global array.
     DB will bloat
     */
    func appendToGlobalArray() {
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
                            email.contacts.append(contact)
                            
                            db.write {
                                db.add(email)
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
                    }
                })
            }
        }
    }
    
    /**
     Append to local array.
     DB will not bloat
     */
    func appendToLocalArray() {
        let firstQueue = DispatchQueue.init(label: "com.test.concurrent", qos: .userInteractive, attributes: .concurrent)
        let secondQueue = DispatchQueue.init(label: "com.test.concurrent2", qos: .userInteractive, attributes: .concurrent)
        
        //Local email array
        var localEmails = [Email]()
        
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
                            email.contacts.append(contact)
                            
                            db.write {
                                db.add(email)
                            }
                        }
                    })
                }
            }
            
            //Read and append to local array, ie localEmails
            secondQueue.async {
                EmailDAL.writeToDBSync({ (db) in
                    let sub = "\(i) Text"
                    
                    if let email = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
                        
                        //Appending to local email array
                        localEmails.append(email)
                    }
                })
            }
        }
    }
    
    //MARK:- Append with Managed & Unmanaged Realm
    
    /**
     Append to global array using a MANAGED email realm object
     DB will bloat
     */
    func appendWithManaged() {
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
            
            //Read and append global email array, using managed email
            secondQueue.async {
                EmailDAL.writeToDBSync({ (db) in
                    let sub = "\(i) Text"
                    
                    if let email = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
                        self.globalEmails.append(email)
                        print("Global email array count:", self.globalEmails.count)
                    }
                })
            }
        }
    }
    
    /**
     Append to global array using an UNMANAGED email realm object
     DB will not bloat
     */
    func appendWithUnmanaged() {
        let firstQueue = DispatchQueue.init(label: "com.test.concurrentUnmanaged", qos: .userInteractive, attributes: .concurrent)
        let secondQueue = DispatchQueue.init(label: "com.test.concurrentUnmanaged2", qos: .userInteractive, attributes: .concurrent)
        
        for i in 0..<10 {
            //Read and Write
            firstQueue.async {
                for j in 0..<500 {
                    EmailDAL.writeToDBSync({ (db) in
                        let sub = "\(i) Text"
                        
                        if let email = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
                            let unmanagedEmail = Email(value: email)
                            
                            let contact = Contact()
                            contact.id = UUID().uuidString
                            contact.name = "\(j) name"
                            
                            db.write {
                                db.add(contact)
                                unmanagedEmail.contacts.append(contact)
                            }
                        }
                    })
                }
            }
            
            //Read and append global email array, using unmanaged email
            secondQueue.async {
                EmailDAL.writeToDBSync({ (db) in
                    let sub = "\(i) Text"
                    
                    if let email = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
                        
                        //Create unmanaged email realm object and append to global array
                        let unmanagedEmail = Email(value: email)
                        self.globalEmails.append(unmanagedEmail)
                        print("Global email array count:", self.globalEmails.count)
                    }
                })
            }
        }
    }

}
