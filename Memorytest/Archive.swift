//
//  Archive.swift
//  Memorytest
//
//  Created by Koh Jia Rong on 2019/7/12.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import UIKit
import RealmSwift

//func getEmail(i:Int, callback: @escaping(_ email: Email?) -> Void) {
//    var email: Email?
//
//    EmailDAL.updateSync({ (db) in
//        let sub = "\(i) Text"
//        if let e = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
//
//            //                print("JJJJJJJJ\(i)", Thread.current)
//
//            //Append managed
//            self.weakEmail = e
//            email = e
//        }
//    })
//
//    print("Weak", self.weakEmail?.subject ?? "nil")
//    callback(email)
//}
//
//func updateTest() {
//    let firstQueue = DispatchQueue.init(label: "com.test.concurrent", qos: .userInteractive, attributes: .concurrent)
//    let secondQueue = DispatchQueue.init(label: "com.test.concurrent2", qos: .userInteractive, attributes: .concurrent)
//
//    for i in 0..<10 {
//        //Managed
//        firstQueue.async {
//            for j in 0..<500 {
//                EmailDAL.writeToDBSync({ (db) in
//                    let sub = "\(i) Text"
//
//                    if let email = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
//                        //                            print("F\(i)", Thread.current)
//
//                        let contact = Contact()
//                        contact.id = UUID().uuidString
//                        contact.name = "\(j) name"
//
//                        db.write {
//                            email.contacts.append(contact)
//                        }
//                    }
//                })
//            }
//        }
//
//        //            secondQueue.async {
//        ////                self.getEmail(i: i, callback: { (_) in
//        ////
//        ////                    //                    print(email)
//        ////                })
//        //                var emailList = [Email]()
//        //
//        //                EmailDAL.writeToDBSync({ (db) in
//        //                    let sub = "\(i) Text"
//        //                    if let email = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
//        //
//        //                        self.weakEmail = email
//        //                        emailList.append(email)
//        //
//        //                        db.write {
//        //                            email.bodyText = "123"
//        //                        }
//        //                    }
//        //
//        //                    self.transferList(emails: emailList)
//        //                })
//        //                print("Weak", self.weakEmail)
//        //
//        //            }
//        //Unmanaged
//        //            firstQueue.async {
//        //                for j in 0..<500 {
//        //                    EmailDAL.writeToDBSync({ (db) in
//        //                        let sub = "\(i) Text"
//        //
//        //                        if let email = db.r.objects(Email.self).filter("bodyText == %@", sub).first {
//        //                            print("F\(i)", Thread.current)
//        //                            let unmanagedEmail = Email(value: email)
//        //
//        //                            let contact = Contact()
//        //                            contact.id = UUID().uuidString
//        //                            contact.name = "\(j) name"
//        //
//        //                            db.write {
//        //                                db.add(contact)
//        //                                unmanagedEmail.contacts.append(contact)
//        //                                db.add(unmanagedEmail)
//        ////                                email.contacts.append(contact)
//        //                            }
//        //                        }
//        //                    })
//        //                }
//        //            }
//
//
//
//        //            firstQueue.async {
//        //                for j in 0..<500 {
//        //                    EmailDAL.writeToDBSync2({ (realm) in
//        //                    do {
//        ////                        let realm = try Realm()
//        //                        let sub = "\(i) Text"
//        //
//        //                        if let email = realm.objects(Email.self).filter("bodyText == %@", sub).first {
//        //                            print("F\(i)", Thread.current)
//        //                            let unmanagedEmail = Email(value: email)
//        //
//        //                            let contact = Contact()
//        //                            contact.id = UUID().uuidString
//        //                            contact.name = "\(j) name"
//        //
//        //                            try realm.write {
//        //                                realm.add(contact, update: true)
//        //                                unmanagedEmail.contacts.append(contact)
//        //                                realm.add(unmanagedEmail, update: true)
//        //                            }
//        //                        }
//        //                    } catch {
//        //
//        //                    }
//        //                })
//        //                }
//        //            }
//        //
//        //
//        //            secondQueue.async {
//        ////                autoreleasepool {
//        //                var emailList = [Email]()
//        //
//        //                    EmailDAL.writeToDBSync2({ (realm) in
//        //                        do {
//        ////                            let realm = try Realm()
//        //                            let sub = "\(i) Text"
//        //                            if let email = realm.objects(Email.self).filter("bodyText == %@", sub).first {
//        ////                                print("JJJJJJ\(i)", Thread.current)
//        //
//        //                                self.weakEmail = email
//        ////                                emailList.append(email)
//        //                                self.emails.append(email)
//        //
//        //                            }
//        //
//        //                            self.transferList(emails: emailList)
//        //                        } catch {
//        //                            print(error.localizedDescription)
//        //                        }
//        //                    })
//        //                print("Weak", self.weakEmail)
//        //
//        ////                }
//        //            }
//
//        //
//        //            firstQueue.async {
//        //                autoreleasepool {
//        //                    do {
//        //                        let realm = try Realm()
//        //                        let sub = "\(i) Text"
//        //
//        //                        if let email = realm.objects(Email.self).filter("bodyText == %@", sub).first {
//        //
//        ////                            let unmanagedEmail = Email(value: email)
//        //
//        //                            for j in 0..<500 {
//        ////                                print("F\(i)", Thread.current)
//        //
//        //                                let contact = Contact()
//        //                                contact.id = UUID().uuidString
//        //                                contact.name = "\(j) name"
//        //
//        //                                try realm.write {
//        //                                    email.contacts.append(contact)
//        //                                }
//        //                            }
//        //                        }
//        //
//        //                    } catch {
//        //                        print(error.localizedDescription)
//        //                    }
//        //                }
//        //            }
//
//        //            secondQueue.async {
//        //                var emailList = [Email]()
//        //
//        //                autoreleasepool {
//        //                    do {
//        //                        let realm = try Realm()
//        //                        let sub = "\(i) Text"
//        //
//        //                        if let email = realm.objects(Email.self).filter("bodyText == %@", sub).first {
//        //
//        //                            //Append managed
//        ////                            autoreleasepool {
//        //                            self.weakEmail = email
//        ////                            self.emails.append(email)
//        //                            emailList.append(email)
//        ////                            }
//        //                            //Append unmanaged
//        ////                            let unmanagedEmail = Email(value: email)
//        ////                            self.emails.append(unmanagedEmail)
//        //                        }
//        //
//        //                        self.transfer(emails: emailList)
//        //                    } catch {
//        //                        print(error.localizedDescription)
//        //                    }
//        //                }
//        //
//        //                print("Weakemail", self.weakEmail)
//        //            }
//    }
//
//}


