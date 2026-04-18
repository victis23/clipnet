import SwiftUI

struct ContentView: View {
    @EnvironmentObject var roleSelectVM: RoleSelectViewModel

    var body: some View {
        Group {
            switch roleSelectVM.selectedRole {
            case .none:
				RoleSelectView()
            case .brand:
                BrandTabView().environmentObject(AppViewModel())
            case .clipper:
                ClipperTabView().environmentObject(AppViewModel())
            }
        }
        .animation(.easeInOut(duration: 0.3), value: roleSelectVM.selectedRole)
    }
}
