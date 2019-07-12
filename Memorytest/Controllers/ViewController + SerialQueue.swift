//
//  ViewController + SerialQueue.swift
//  Memorytest
//
//  Created by Koh Jia Rong on 2019/7/12.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import UIKit
import RealmSwift

extension ViewController {
    
    //MARK:- Serial Queue
    
    /**
     Write on one single background thread
     Realm DB does not bloat.
     */
    func saveinSerialQueue() {
        print("Saving in serial queue")
        
        let serialQueue = DispatchQueue.init(label: "com.test.serial", qos: .userInitiated)
        
        for i in 1..<10000 {
            serialQueue.async {
                print(Thread.current, i)
                let email = Email()
                email.subject = "\(i) Subject"
                email.bodyText = "\(i) BodyText"
                email.timestamp = Date().timeIntervalSince1970
                
                do {
                    let realm = try Realm()
                    
                    try realm.write {
                        realm.add(email, update: true)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Write on one single background thread, with autorelease
     Realm DB does not bloat.
     */
    func saveinSerialQueueWithAutorelease() {
        print("Saving in serial queue with autorelease")
        
        let serialQueue = DispatchQueue.init(label: "com.test.serialAutorelease", qos: .userInitiated)
        
        for i in 1..<10000 {
            serialQueue.async {
                autoreleasepool{
                    print(Thread.current, i)
                    let email = Email()
                    email.subject = "\(i) Subject"
                    email.bodyText = "\(i) BodyText"
                    email.timestamp = Date().timeIntervalSince1970
                    
                    do {
                        let realm = try Realm()
                        
                        try realm.write {
                            realm.add(email, update: true)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}
