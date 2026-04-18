import SwiftUI

@main
struct ClipNetApp: App {
	@StateObject private var roleSelectViewModel = {
		let roleSelectViewModel = RoleSelectViewModel()
		roleSelectViewModel.saveUserRoleSelection()
		if let savedRole = UserDefaults.standard.string(forKey: "role") {
			roleSelectViewModel.selectedRole = AppRole(rawValue: savedRole)
		}

		return roleSelectViewModel
	}()

    var body: some Scene {
        return WindowGroup {
            ContentView()
                .environmentObject(roleSelectViewModel)
        }
    }
}
