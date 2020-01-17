//
//  BlogIdea.swift
//  BlogIdeaList-SwiftUI
//
//  Created by Andrew Bancroft on 7/30/19.
//  Copyright © 2019 Andrew Bancroft. All rights reserved.
//
// ❇️ Alerts you to Core Data pieces
// ℹ️ Alerts you to general info about what my brain was thinking when I wrote the code
//

import Foundation
import CoreData

// ❇️ BlogIdea code generation is turned OFF in the xcdatamodeld file
public class DeviceIdea: NSManagedObject, Identifiable {
    @NSManaged public var deviceTitle: String?
    @NSManaged public var deviceDescription: String?
}

extension DeviceIdea {
    // ❇️ The @FetchRequest property wrapper in the ContentView will call this function
    static func allDevicesFetchRequest() -> NSFetchRequest<DeviceIdea> {
        let request: NSFetchRequest<DeviceIdea> = DeviceIdea.fetchRequest() as! NSFetchRequest<DeviceIdea>
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "deviceTitle", ascending: true)]
          
        return request
    }
}
