//
//  ContentView.swift
//  DeviceIdeaList-SwiftUI
//
//  Created by Andrew Bancroft on 7/30/19.
//  Copyright © 2019 Andrew Bancroft. All rights reserved.
//
// ❇️ Alerts you to Core Data pieces
// ℹ️ Alerts you to general info about what my brain was thinking when I wrote the code
//

import SwiftUI
import CoreData

struct ContentView: View {
    // ❇️ Core Data property wrappers
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❇️ The DeviceIdea class has an `allIdeasFetchRequest` static function that can be used here
    @FetchRequest(fetchRequest: DeviceIdea.allDevicesFetchRequest()) var DeviceIdeas: FetchedResults<DeviceIdea>
    
    // ℹ️ Temporary in-memory storage for adding new blog ideas
    @State private var newIdeaTitle = ""
    @State private var newIdeaDescription = ""
    
    // ℹ️ Two sections: Add Blog Idea at the top, followed by a listing of the ideas in the persistent store
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add Device Idea")) {
                    VStack {
                        VStack {
                            TextField("Device title", text: self.$newIdeaTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Device description", text: self.$newIdeaDescription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack {
                            Button(action: ({
                                // ❇️ Initializes new DeviceIdea and saves using the @Environment's managedObjectContext
                                let idea = DeviceIdea(context: self.managedObjectContext)
                                idea.deviceTitle = self.newIdeaTitle
                                idea.deviceDescription = self.newIdeaDescription
                                
                                do {
                                    try self.managedObjectContext.save()
                                } catch {
                                    print(error)
                                }
                                
                                // ℹ️ Reset the temporary in-memory storage variables for the next new blog idea!
                                self.newIdeaTitle = ""
                                self.newIdeaDescription = ""
                            })) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .imageScale(.large)
                                    Text("Add Device")
                                }
                            }
                            .padding()
                        }
                    }
                }
                .font(.headline)



                Section(header: Text("Device Ideas")) {
                    ForEach(self.DeviceIdeas) { DeviceIdea in
                        NavigationLink(destination: EditView(DeviceIdea: DeviceIdea)) {
                            VStack(alignment: .leading) {
                                Text(DeviceIdea.deviceTitle ?? "")
                                    .font(.headline)
                                Text(DeviceIdea.deviceDescription ?? "")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete { (indexSet) in // Delete gets triggered by swiping left on a row
                        // ❇️ Gets the DeviceIdea instance out of the DeviceIdeas array
                        // ❇️ and deletes it using the @Environment's managedObjectContext
                        let DeviceIdeaToDelete = self.DeviceIdeas[indexSet.first!]
                        self.managedObjectContext.delete(DeviceIdeaToDelete)
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                    }
                }
                .font(.headline)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Device Idea List"))
            .navigationBarItems(trailing: EditButton())
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
}
#endif
