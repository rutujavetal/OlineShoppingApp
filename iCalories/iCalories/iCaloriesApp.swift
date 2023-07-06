//
//  iCaloriesApp.swift
//  iCalories
//
//  Created by Rutuja Vetal on 15/04/23.
//

import SwiftUI

@main
struct iCaloriesApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
