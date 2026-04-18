import SwiftUI

struct CampaignDetailView: View {
    let campaign: Campaign

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard
                statsGrid
                if let bounty = campaign.bounty {
                    bountyCard(bounty)
                }
                platformsCard
                progressCard
                actionsCard
            }
            .padding(20)
            .padding(.bottom, 32)
        }
        .background(Color.cnSurface.ignoresSafeArea())
        .navigationTitle(campaign.creatorName)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header
    private var headerCard: some View {
        HStack(spacing: 16) {
            CreatorAvatar(initials: campaign.initials, accent: campaign.accent, size: 56)

            VStack(alignment: .leading, spacing: 6) {
                Text(campaign.creatorName)
                    .font(.cnHeading())

                StatusBadge(status: campaign.status)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(campaign.cpmRate.currency)
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundColor(campaign.accent.accent)
                Text("per 1K views")
                    .font(.cnCaption())
                    .foregroundColor(.cnMuted)
            }
        }
        .padding(18)
        .cardStyle()
    }

    // MARK: - Stats Grid
    private var statsGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 12
        ) {
            DetailStat(label: "Total Views", value: campaign.totalViews.shortFormatted, color: .cnTeal)
            DetailStat(label: "Clippers", value: "\(campaign.clippersCount)", color: .cnPurple)
            DetailStat(label: "Total Clips", value: campaign.clipsCount.shortFormatted, color: .cnBlue)
            DetailStat(label: "Paid Out", value: campaign.paidOut.shortCurrency, color: .cnAmber)
        }
    }

    // MARK: - Bounty Card
    private func bountyCard(_ bounty: Bounty) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.cnAmber.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: "star.fill")
                    .foregroundColor(.cnAmber)
                    .font(.system(size: 18))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Active Bounty")
                    .font(.cnSubhead())
                Text("Earn \(bounty.payoutAmount.currency) when you hit \(bounty.thresholdViews.shortFormatted) views")
                    .font(.cnCaption())
                    .foregroundColor(.cnMuted)
            }

            Spacer()
        }
        .padding(16)
        .background(Color(hex: "FFF8ED"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.cnAmber.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Platforms
    private var platformsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PLATFORMS")
                .font(.cnLabel())
                .foregroundColor(.cnMuted)

            HStack(spacing: 8) {
                ForEach(campaign.platforms) { p in
                    PlatformTag(platform: p)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    // MARK: - Progress
    private var progressCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("BUDGET")
                    .font(.cnLabel())
                    .foregroundColor(.cnMuted)
                Spacer()
                Text("\(Int(campaign.capFraction * 100))% used")
                    .font(.cnCaption())
                    .foregroundColor(campaign.capFraction >= 1.0 ? .cnDanger : .cnMuted)
            }

            CapProgressBar(fraction: campaign.capFraction, height: 6)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(campaign.paidOut.currency)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                    Text("paid out")
                        .font(.cnCaption())
                        .foregroundColor(.cnMuted)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(campaign.campaignCap.currency)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                    Text("campaign cap")
                        .font(.cnCaption())
                        .foregroundColor(.cnMuted)
                }
            }

            Divider()

            HStack {
                Label("Min. payout threshold", systemImage: "chart.line.uptrend.xyaxis")
                    .font(.cnCaption())
                    .foregroundColor(.cnMuted)
                Spacer()
                Text("\(campaign.minimumPayoutViews.shortFormatted) views")
                    .font(.cnCaption())
                    .foregroundColor(.cnText)
            }
        }
        .padding(16)
        .cardStyle()
    }

    // MARK: - Actions
    private var actionsCard: some View {
        VStack(spacing: 10) {
            NavyButton(title: "Pause Campaign") {}
            Button("End Campaign") {}
                .font(.cnBody())
                .foregroundColor(.cnDanger)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(hex: "FEE2E2"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

private struct DetailStat: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                Text(label.uppercased())
                    .font(.cnLabel())
                    .foregroundColor(.cnMuted)
            }
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(.cnText)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .surfaceStyle()
    }
}
