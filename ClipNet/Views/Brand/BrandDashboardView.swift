import SwiftUI

struct BrandDashboardView: View {
    @EnvironmentObject var campaignViewModel: CampaignViewModel
    @State private var selectedCampaign: Campaign? = nil

    var body: some View {
		ScrollView {
			VStack(spacing: 24) {
				statsSection
				campaignListSection
			}
			.padding(.top, 16)
			.padding(.bottom, 32)
		}
		.background(Color.cnSurface.ignoresSafeArea())
		.navigationTitle("Campaigns")
		.navigationBarTitleDisplayMode(.large)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					campaignViewModel.isShowingCreateCampaign = true
				} label: {
					Label("New Campaign", systemImage: "plus")
						.labelStyle(.iconOnly)
						.font(.system(size: 18, weight: .semibold))
						.foregroundColor(.cnAmber)
				}
			}
		}
		.navigationDestination(item: $selectedCampaign) { campaign in
			CampaignDetailView(campaign: campaign)
		}
    }

    // MARK: - Stats Section
    private var statsSection: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
            spacing: 10
        ) {
            StatCard(label: "Views", value: campaignViewModel.totalViews.shortFormatted, accentColor: .cnTeal)
            StatCard(label: "Paid Out", value: campaignViewModel.totalPaidOut.shortCurrency, accentColor: .cnAmber)
            StatCard(label: "Active", value: "\(campaignViewModel.activeCampaigns)", accentColor: .cnSuccess)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Campaign List
    private var campaignListSection: some View {
        VStack(spacing: 12) {
            HStack {
                SectionHeader(title: "All Campaigns")
                Spacer()
//                Button {
//					campaignViewModel.isShowingCreateCampaign = true
//                } label: {
//                    HStack(spacing: 4) {
//                        Image(systemName: "plus")
//                        Text("New")
//                    }
//                    .font(.system(size: 13, weight: .semibold))
//                    .foregroundColor(.cnNavy)
//                    .padding(.horizontal, 14)
//                    .padding(.vertical, 7)
//                    .background(Color.cnAmber)
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
//                }
            }
            .padding(.horizontal, 20)

            if campaignViewModel.campaigns.isEmpty {
                EmptyStateView(
                    systemImage: "bolt.slash",
                    title: "No campaigns yet",
                    subtitle: "Create your first campaign to start growing your audience."
                )
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(campaignViewModel.campaigns) { campaign in
                        CampaignRowView(campaign: campaign)
                            .padding(.horizontal, 20)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedCampaign = campaign
                            }
                    }
                }
            }
        }
    }
}

// MARK: - Campaign Row
struct CampaignRowView: View {
    let campaign: Campaign

    var body: some View {
        VStack(spacing: 0) {
            // Top: avatar + name + status
            HStack(spacing: 12) {
                CreatorAvatar(initials: campaign.initials, accent: campaign.accent, size: 44)

                VStack(alignment: .leading, spacing: 3) {
                    Text(campaign.creatorName)
                        .font(.cnSubhead())
                        .foregroundColor(.cnText)

                    HStack(spacing: 6) {
                        ForEach(campaign.platforms.prefix(3)) { p in
                            PlatformTag(platform: p, compact: true)
                        }
                        if campaign.platforms.count > 3 {
                            Text("+\(campaign.platforms.count - 3)")
                                .font(.cnLabel())
                                .foregroundColor(.cnMuted)
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(campaign.cpmRate.currency)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(campaign.accent.accent)
                    Text("per 1K")
                        .font(.cnLabel())
                        .foregroundColor(.cnMuted)
                }
            }
            .padding(.horizontal, 14)
            .padding(.top, 14)

            // Divider
            Divider()
                .padding(.horizontal, 14)
                .padding(.top, 12)

            // Bottom: stats + progress
            HStack(spacing: 0) {
                MiniStat(label: "Views", value: campaign.totalViews.shortFormatted)
                Divider().frame(height: 28)
                MiniStat(label: "Clippers", value: "\(campaign.clippersCount)")
                Divider().frame(height: 28)
                MiniStat(label: "Clips", value: campaign.clipsCount.shortFormatted)
                Spacer()
                StatusBadge(status: campaign.status)
                    .padding(.trailing, 14)
            }
            .padding(.vertical, 10)

            // Progress bar
            VStack(spacing: 4) {
                HStack {
                    Text(campaign.paidOut.shortCurrency + " paid")
                        .font(.cnCaption())
                        .foregroundColor(.cnMuted)
                    Spacer()
                    Text(campaign.campaignCap.shortCurrency + " cap")
                        .font(.cnCaption())
                        .foregroundColor(.cnMuted)
                }
                CapProgressBar(fraction: campaign.capFraction)
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .cardStyle()
    }
}

private struct MiniStat: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundColor(.cnText)
            Text(label)
                .font(.cnLabel())
                .foregroundColor(.cnMuted)
        }
        .frame(maxWidth: .infinity)
    }
}
