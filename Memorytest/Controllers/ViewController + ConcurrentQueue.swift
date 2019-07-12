//
//  ViewController + ConcurrentQueue.swift
//  Memorytest
//
//  Created by Koh Jia Rong on 2019/7/12.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import UIKit
import RealmSwift

extension ViewController {
    
    //MARK:- Concurrent Queue
    /**
     This method writes to realm in multiple threads in the background.
     Realm DB bloats to >1GB at the end of writes.
     Note that there is no autoreleasepool written.
     */
    func saveInConcurrentQueue() {
        print("Saving in concurrent queue")
        
        let concurrentQueue = DispatchQueue.init(label: "com.test.concurrent", qos: .userInitiated, attributes: .concurrent)
        
        for i in 1...10000 {
            concurrentQueue.async {
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
     Similar to saveToRealmInConcurrentQueue
     Includes autoreleasepool in background async thread.
     Realm DB will not bloat
     */
    func saveInConcurrentQueueWithAutorelease() {
        print("Saving in concurrent queue with autorelease")
        
        let concurrentQueue = DispatchQueue.init(label: "com.test.concurrentAutorelease", qos: .userInitiated, attributes: .concurrent)
        
        for i in 1...10000 {
            concurrentQueue.async {
                autoreleasepool {
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
