//
//  FileMonitorManager.swift
//  FileMonitorSwift
//
//  Created by liuhui on 2019/7/3.
//  Copyright © 2019 lh. All rights reserved.
//

import Foundation
import RealmSwift

protocol FileSizeDelegate {
    func fileSizeDidUpdate(size: String)
}

class FileMonitorManager: NSObject, EdoFileMonitorDelegate {
    
    static let sharedInst = FileMonitorManager()
    
    var fileMonitor:EdoFileMonitor?
    var fileSizeDelegate: FileSizeDelegate?
    
    private override init() {
        super.init()
    }

    public func register() {
        let filePath = Realm.Configuration.defaultConfiguration.fileURL!
        print("RegisterFileMonitor", filePath)
        
        let fileSize = Double(self.getSize(filePath))/(1024*1024)
        let formatSize = String(format:"%.3f",fileSize)
        print("RegisterFileMonitor fileSize:\(formatSize)M");
        
        self.fileMonitor = EdoFileMonitor(url:filePath)
        self.fileMonitor?.delegate = self
    }

    //MARK:monitor delegate
    func fileMonitor( _ fileMonitor:EdoFileMonitor ,didSee didSeeChange:EdoFileMonitorChangeType){
        
        if (didSeeChange == EdoFileMonitorChangeType.size)
        {
            let fileSize = Double(self.getSize(fileMonitor.fileURL))/(1024.0*1024.0)
            let formatSize = String(format:"%.3f",fileSize)
            self.fileSizeDelegate?.fileSizeDidUpdate(size: formatSize)
        }
    }
    
    func getSize(_ url: URL)->UInt64
    {
        var fileSize : UInt64 = 0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
        } catch {
            print("Error: \(error)")
        }
        return fileSize
    }
    
    deinit {
    }
    
}
