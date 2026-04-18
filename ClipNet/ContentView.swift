import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        Group {
            switch vm.selectedRole {
            case .none:
                RoleSelectView()
            case .brand:
                BrandTabView()
            case .clipper:
                ClipperTabView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: vm.selectedRole)
    }
}
