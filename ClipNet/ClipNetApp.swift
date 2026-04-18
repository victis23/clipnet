import SwiftUI

@main
struct ClipNetApp: App {
    @StateObject private var roleSelectViewModel = RoleSelectViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(roleSelectViewModel)
        }
    }
}
