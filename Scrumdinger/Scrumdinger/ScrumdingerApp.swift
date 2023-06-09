//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by 최우영 on 2023/03/30.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumsView(scrums: DailyScrum.sampleData)
            }
        }
    }
}
