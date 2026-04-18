import SwiftUI

struct ClipperTabView: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            BrowseCampaignsView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
                .tag(0)

            MyClipsView()
                .tabItem {
                    Label("My Clips", systemImage: "scissors")
                }
                .tag(1)

            ClipperEarningsView()
                .tabItem {
                    Label("Earnings", systemImage: "dollarsign.circle.fill")
                }
                .tag(2)

            ClipperSettingsView()
                .tabItem {
                    Label("Account", systemImage: "person.circle.fill")
                }
                .tag(3)
        }
        .tint(.cnTeal)
    }
}

// MARK: - Settings (placeholder)
private struct ClipperSettingsView: View {
    @EnvironmentObject var vm: RoleSelectViewModel

    var body: some View {
        NavigationStack {
            List {
                Section("Connected Accounts") {
                    LinkedAccountRow(platform: .tiktok, isLinked: true)
                    LinkedAccountRow(platform: .instagram, isLinked: false)
                    LinkedAccountRow(platform: .youtube, isLinked: true)
                    LinkedAccountRow(platform: .x, isLinked: false)
                }
                Section("Payout") {
                    Label("Payout Method", systemImage: "dollarsign.circle")
                    Label("USDT Wallet", systemImage: "bitcoinsign.circle")
                    Label("Payment History", systemImage: "clock")
                }
                Section("FTC") {
                    Label("Disclosure Settings", systemImage: "shield.lefthalf.filled")
                }
                Section {
                    Button(role: .destructive) {
                        vm.selectedRole = nil
                    } label: {
                        Label("Switch Role", systemImage: "arrow.left.arrow.right")
                    }
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

private struct LinkedAccountRow: View {
    let platform: Platform
    let isLinked: Bool

    var body: some View {
        HStack {
            Label(platform.rawValue, systemImage: platform.sfSymbol)
            Spacer()
            if isLinked {
                HStack(spacing: 4) {
                    Circle().fill(Color.cnSuccess).frame(width: 6, height: 6)
                    Text("Linked").font(.cnCaption()).foregroundColor(.cnSuccess)
                }
            } else {
                Text("Connect").font(.cnCaption()).foregroundColor(.cnAmber)
            }
        }
    }
}
