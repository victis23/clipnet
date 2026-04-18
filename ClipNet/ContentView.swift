import SwiftUI

struct ContentView: View {
    @EnvironmentObject var roleSelectViewModel: RoleSelectViewModel
    @StateObject private var campaignViewModel = CampaignViewModel()
    @StateObject private var clipperViewModel = ClipperViewModel()

    var body: some View {
        Group {
            switch roleSelectViewModel.selectedRole {
            case .none:
				RoleSelectView()
            case .brand:
                BrandTabView().environmentObject(campaignViewModel)
            case .clipper:
				ClipperTabView().environmentObject(clipperViewModel).environmentObject(campaignViewModel)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: roleSelectViewModel.selectedRole)
    }
}
