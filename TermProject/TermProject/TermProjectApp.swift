//
//  youtubeApp.swift
//  youtube
//
//  Created by JPL-ST-MAC-289 on 12/4/23.
//

import SwiftUI
import Firebase

@main
struct TermProjectApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
