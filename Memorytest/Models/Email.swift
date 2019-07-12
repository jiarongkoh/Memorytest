//
//  Email.swift
//  Memorytest
//
//  Created by Koh Jia Rong on 2019/7/12.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import RealmSwift

class Email: Object {
    @objc dynamic var subject = ""
    @objc dynamic var bodyText = ""
    @objc dynamic var timestamp = 0.0
    let contacts = List<Contact>()
    
    override static func primaryKey() -> String? {
        return "subject"
    }
}
