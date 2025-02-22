//
//  NoteItApp.swift
//  NoteIt
//
//  Created by sachin kumar on 19/02/25.
//

import SwiftUI

@main
struct NoteItApp: App {
    let persistenceController = CoreDataStack.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
