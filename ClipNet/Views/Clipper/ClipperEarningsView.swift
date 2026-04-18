import SwiftUI

struct ClipperEarningsView: View {
    @EnvironmentObject var clipperViewModel: ClipperViewModel
	@EnvironmentObject var campaignViewModel: CampaignViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    earningsSummaryCard
                    breakdownSection
                    recentPayoutsSection
                }
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .background(Color.cnSurface.ignoresSafeArea())
            .navigationTitle("Earnings")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Summary Card
    private var earningsSummaryCard: some View {
        VStack(spacing: 0) {
            // Navy header band
            VStack(spacing: 8) {
                Text("TOTAL EARNED")
                    .font(.cnLabel())
                    .foregroundColor(.cnMuted)

                Text(clipperViewModel.totalEarned.currency)
                    .font(.system(size: 44, weight: .black, design: .monospaced))
                    .foregroundColor(.cnAmber)

                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.cnAmber)
                        .frame(width: 6, height: 6)
                    Text("\(clipperViewModel.myClips.filter { $0.status == .paid }.count) clips paid out")
                        .font(.cnCaption())
                        .foregroundColor(.cnMuted)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .background(Color.cnNavy)

            // Pending row
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("PENDING PAYOUT")
                        .font(.cnLabel())
                        .foregroundColor(.cnMuted)
                    Text(clipperViewModel.pendingEarnings.currency)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(.cnAmber)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("OPEN CAMPAIGNS")
                        .font(.cnLabel())
                        .foregroundColor(.cnMuted)
                    Text("\(campaignViewModel.activeCampaigns)")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(.cnTeal)
                }
            }
            .padding(18)
            .background(Color.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }

    // MARK: - Breakdown
    private var breakdownSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "By Platform")
                .padding(.horizontal, 20)

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 10
            ) {
                ForEach(platformBreakdown, id: \.0) { (platform, total) in
                    PlatformEarningTile(platform: platform, total: total)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var platformBreakdown: [(Platform, Double)] {
        var totals: [Platform: Double] = [:]
        for clip in clipperViewModel.myClips {
            totals[clip.platform, default: 0] += clip.earnedAmount
        }
        return Platform.allCases
            .compactMap { p -> (Platform, Double)? in
                guard let v = totals[p], v > 0 else { return nil }
                return (p, v)
            }
            .sorted { $0.1 > $1.1 }
    }

    // MARK: - Recent Payouts
    private var recentPayoutsSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Recent Clips")
                .padding(.horizontal, 20)

            LazyVStack(spacing: 10) {
                ForEach(clipperViewModel.myClips) { clip in
                    EarningsClipRow(clip: clip)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}

// MARK: - Platform Earning Tile
private struct PlatformEarningTile: View {
    let platform: Platform
    let total: Double

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: platform.sfSymbol)
                .font(.system(size: 18))
                .foregroundColor(.cnNavy)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(platform.rawValue)
                    .font(.cnCaption())
                    .foregroundColor(.cnMuted)
                Text(total.currency)
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                    .foregroundColor(.cnText)
            }

            Spacer()
        }
        .padding(14)
        .surfaceStyle()
    }
}

// MARK: - Earnings Clip Row
private struct EarningsClipRow: View {
    let clip: ClipSubmission

    var body: some View {
        HStack(spacing: 12) {
            // Left: platform badge
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.cnSurface)
                    .frame(width: 40, height: 40)
                Image(systemName: clip.platform.sfSymbol)
                    .font(.system(size: 16))
                    .foregroundColor(.cnNavy)
            }

            // Middle: info
            VStack(alignment: .leading, spacing: 3) {
                Text(clip.creatorName)
                    .font(.cnSubhead())
                Text("\(clip.platform.rawValue)  ·  \(clip.views.shortFormatted) views")
                    .font(.cnCaption())
                    .foregroundColor(.cnMuted)
            }

            Spacer()

            // Right: earned + status
            VStack(alignment: .trailing, spacing: 4) {
                Text(clip.earnedAmount.currency)
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                ClipStatusBadge(status: clip.status)
            }
        }
        .padding(14)
        .cardStyle()
    }
}
