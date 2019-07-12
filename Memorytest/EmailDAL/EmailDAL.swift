//
//  EmailDAL.swift
//  Memorytest
//
//  Created by Koh Jia Rong on 2019/5/31.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//


//file monitor + try realm
import Foundation
import RealmSwift

class EmailDAL: NSObject {
    
    static func getRealm() -> Realm {
        var realm: Realm!
        
        do {
            realm = try Realm()
        } catch {
            print(error.localizedDescription)
        }
        realm.refresh()
        return realm
    }
    
    static func updateAsync(_ block: @escaping (EmailDB) -> Void) {
        let fastQueue = DispatchQueue.init(label: "com.fastQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .never)
        fastQueue.async {
            block(EmailDB())
        }
    }
    
    static func updateSync(_ block: (EmailDB) -> Void) {
        autoreleasepool {
            block(EmailDB())
        }
    }
    
    static func writeToDBSync(_ block: (EmailDB) -> ()) {
        autoreleasepool {
            let db = EmailDB()
            db.write {
                block(db)
            }
        }
    }
    
    static func writeToDBSync2(_ block: (Realm) -> ()) {
//        autoreleasepool {
            do {
                let realm = try Realm()
                block(realm)
            } catch {
                
            }
//        }
    }
    
}

class EmailDB: NSObject {
    var r: Realm!
    
    override init() {
        r = EmailDAL.getRealm()
        super.init()
    }
    
    func add(_ entity: Object) {
        autoreleasepool {
            do {
                if r.isInWriteTransaction {
                    r.add(entity, update: true)
                    
                } else {
                    try r.write {
                        r.add(entity, update: true)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func write(block: () -> ()) {
        autoreleasepool {
            do {
                if r.isInWriteTransaction {
                    block()
                } else {
                    try r.write {
                        block()
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
