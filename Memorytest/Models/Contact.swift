//
//  Contact.swift
//  Memorytest
//
//  Created by Koh Jia Rong on 2019/7/12.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import RealmSwift

class Contact: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
