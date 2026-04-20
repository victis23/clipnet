import SwiftUI

struct BrandTabView: View {
    @EnvironmentObject var campaignViewModel: CampaignViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
			NavigationStack {
				BrandDashboardView()
			}
			.tabItem {
				Label("Campaigns", systemImage: "bolt.fill")
			}
			.tag(0)
			
			NavigationStack {
				BrandAnalyticsView()
			}
			.tabItem {
				Label("Analytics", systemImage: "chart.bar.fill")
			}
			.tag(1)
			
			NavigationStack {
				BrandSettingsView()
			}
			.tabItem {
				Label("Settings", systemImage: "gearshape.fill")
			}
			.tag(2)
        }
        .tint(.cnAmber)
        .sheet(isPresented: $campaignViewModel.isShowingCreateCampaign) {
            CreateCampaignView()
        }
    }
}

// MARK: - Analytics (placeholder)
private struct BrandAnalyticsView: View {
    @EnvironmentObject var campaignViewModel: CampaignViewModel

    var body: some View {
		ScrollView {
			VStack(spacing: 20) {
				LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
					StatCard(label: "Total Views", value: campaignViewModel.totalViews.shortFormatted, accentColor: .cnTeal)
					StatCard(label: "Paid Out", value: campaignViewModel.totalPaidOut.shortCurrency, accentColor: .cnAmber)
					StatCard(label: "Campaigns", value: "\(campaignViewModel.campaigns.count)", accentColor: .cnPurple)
					StatCard(label: "Active", value: "\(campaignViewModel.activeCampaigns)", accentColor: .cnSuccess)
				}
				.padding(.horizontal, 20)

				VStack(alignment: .leading, spacing: 12) {
					SectionHeader(title: "Top Campaigns by Views")
						.padding(.horizontal, 20)
					ForEach(campaignViewModel.campaigns.sorted { $0.totalViews > $1.totalViews }.prefix(3)) { c in
						AnalyticsRow(campaign: c)
							.padding(.horizontal, 20)
					}
				}
			}
			.padding(.top, 20)
		}
		.background(Color.cnSurface.ignoresSafeArea())
		.navigationTitle("Analytics")
		.navigationBarTitleDisplayMode(.large)
    }
}

private struct AnalyticsRow: View {
    let campaign: Campaign

    var body: some View {
        HStack(spacing: 12) {
            CreatorAvatar(initials: campaign.initials, accent: campaign.accent, size: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(campaign.creatorName).font(.cnSubhead())
                Text("\(campaign.clipsCount.shortFormatted) clips").font(.cnCaption()).foregroundColor(.cnMuted)
            }
            Spacer()
            Text(campaign.totalViews.shortFormatted)
                .font(.cnMono())
                .foregroundColor(.cnAmber)
        }
        .padding(12)
        .cardStyle()
    }
}

// MARK: - Settings (placeholder)
private struct BrandSettingsView: View {
    @EnvironmentObject var roleSelectViewModel: RoleSelectViewModel

    var body: some View {
		List {
			Section("Account") {
				Label("Profile", systemImage: "person.circle")
				Label("Billing", systemImage: "creditcard")
				Label("Notifications", systemImage: "bell")
			}
			Section("Platform") {
				Label("API Integrations", systemImage: "link")
				Label("FTC Disclosure Settings", systemImage: "shield.lefthalf.filled")
				Label("Payout Methods", systemImage: "dollarsign.circle")
			}
			Section {
				Button(role: .destructive) {
					roleSelectViewModel.selectedRole = nil
				} label: {
					Label("Switch Role", systemImage: "arrow.left.arrow.right")
				}
			}
		}
		.navigationTitle("Settings")
		.navigationBarTitleDisplayMode(.large)
	}
}
