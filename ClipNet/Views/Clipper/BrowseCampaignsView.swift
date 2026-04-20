import SwiftUI

struct BrowseCampaignsView: View {
    @EnvironmentObject var campaignViewModel: CampaignViewModel

    @State private var platformFilter: Platform? = nil
    @State private var selectedCampaign: Campaign? = nil
    @State private var searchText = ""

    private var filteredCampaigns: [Campaign] {
		campaignViewModel.campaigns
            .filter { $0.status == .active }
            .filter { c in
                if let filter = platformFilter { return c.platforms.contains(filter) }
                return true
            }
            .filter { c in
                if searchText.isEmpty { return true }
                return c.creatorName.localizedCaseInsensitiveContains(searchText)
            }
    }

    var body: some View {
		VStack(spacing: 0) {
			// Filter bar
			filterBar
				.padding(.top, 8)
				.padding(.bottom, 12)
				.padding(.horizontal, 20)

			// Campaign list
			if filteredCampaigns.isEmpty {
				Spacer()
				EmptyStateView(
					systemImage: "magnifyingglass",
					title: "No campaigns found",
					subtitle: "Try adjusting your platform filter."
				)
				Spacer()
			} else {
				ScrollView {
					LazyVStack(spacing: 12) {
						ForEach(filteredCampaigns) { campaign in
							CampaignCard(campaign: campaign)
								.padding(.horizontal, 20)
								.contentShape(Rectangle())
								.onTapGesture {
									selectedCampaign = campaign
								}
						}
					}
					.padding(.bottom, 32)
					.padding(.top, 4)
				}
			}
		}
		.background(Color.cnSurface.ignoresSafeArea())
		.navigationTitle("Browse")
		.navigationBarTitleDisplayMode(.large)
		.searchable(text: $searchText, prompt: "Search creators...")
		.navigationDestination(item: $selectedCampaign) { c in
			CampaignApplyView(campaign: c)
		}
    }

    // MARK: - Filter Bar
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "All", isSelected: platformFilter == nil) {
                    platformFilter = nil
                }
                ForEach(Platform.allCases) { p in
                    FilterChip(label: p.rawValue, isSelected: platformFilter == p) {
                        platformFilter = platformFilter == p ? nil : p
                    }
                }
            }
        }
    }
}

// MARK: - Campaign Card
struct CampaignCard: View {
    let campaign: Campaign

    var body: some View {
        VStack(spacing: 0) {
            // Accent bar
            Rectangle()
                .fill(campaign.accent.accent)
                .frame(height: 3)

            VStack(spacing: 12) {
                // Header row
                HStack(alignment: .top, spacing: 12) {
                    CreatorAvatar(initials: campaign.initials, accent: campaign.accent, size: 46)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(campaign.creatorName)
                            .font(.cnSubhead())
                        HStack(spacing: 6) {
                            ForEach(campaign.platforms.prefix(3)) { p in
                                PlatformTag(platform: p, compact: true)
                            }
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(campaign.cpmRate.currency)
                            .font(.system(size: 22, weight: .bold, design: .monospaced))
                            .foregroundColor(campaign.accent.accent)
                        Text("per 1K views")
                            .font(.cnLabel())
                            .foregroundColor(.cnMuted)

                        if let bounty = campaign.bounty {
                            Text("+\(bounty.payoutAmount.shortCurrency) bounty")
                                .font(.cnLabel())
                                .foregroundColor(.cnAmber)
                        }
                    }
                }

                Divider()

                // Stats row
                HStack {
                    CampaignCardStat(label: "Clippers", value: "\(campaign.clippersCount)")
                    Divider().frame(height: 24)
                    CampaignCardStat(label: "Views", value: campaign.totalViews.shortFormatted)
                    Divider().frame(height: 24)
                    CampaignCardStat(label: "Min Views", value: campaign.minimumPayoutViews.shortFormatted)
                    Spacer()
                    Text("Budget: \(Int(campaign.capFraction * 100))%")
                        .font(.cnCaption())
                        .foregroundColor(campaign.capFraction > 0.8 ? .cnDanger : .cnMuted)
                }

                // Apply button
                HStack {
                    Spacer()
                    HStack(spacing: 6) {
                        Text("Apply to clip")
                            .font(.system(size: 14, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.cnNavy)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.cnAmber)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(16)
        }
        .cardStyle()
    }
}

private struct CampaignCardStat: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(.cnText)
            Text(label)
                .font(.cnLabel())
                .foregroundColor(.cnMuted)
        }
        .frame(minWidth: 60)
    }
}

// MARK: - Filter Chip
private struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .foregroundColor(isSelected ? .cnNavy : .cnText)
                .background(isSelected ? Color.cnTeal : Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(isSelected ? Color.cnTeal : Color.cnBorder, lineWidth: 0.5)
                )
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
