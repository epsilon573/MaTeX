//
//  MatexApp.swift
//  Matex
//
//  Created by Sahil Sharma on 04/04/23.
//

import SwiftUI

@main
struct MatexApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase)
    var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase){newPhaseScene in
            switch newPhaseScene{
            case .background:
                persistenceController.save()
            case .inactive:
                print("Scene is in Inactive")
            case .active:
                print("Scene is in Active")
            @unknown default:
                print("Unknown")
            }
        }
    }
}


