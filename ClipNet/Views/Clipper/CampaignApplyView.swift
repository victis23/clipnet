import SwiftUI

struct CampaignApplyView: View {
    let campaign: Campaign
    @Environment(\.dismiss) private var dismiss
    @State private var hasApplied = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero CPM block
                cpmHero

                // Key info
                infoGrid

                // Requirements card
                requirementsCard

                // Bounty card
                if let bounty = campaign.bounty {
                    bountyCard(bounty)
                }

                // Platform list
                platformsCard

                // Apply / applied button
                if hasApplied {
                    appliedConfirmation
                } else {
                    AmberButton(title: "Apply to This Campaign") {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            hasApplied = true
                        }
                    }
                }
            }
            .padding(20)
            .padding(.bottom, 40)
        }
        .background(Color.cnSurface.ignoresSafeArea())
        .navigationTitle(campaign.creatorName)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - CPM Hero
    private var cpmHero: some View {
        VStack(spacing: 6) {
            CreatorAvatar(initials: campaign.initials, accent: campaign.accent, size: 64)
                .padding(.bottom, 4)

            Text(campaign.cpmRate.currency)
                .font(.system(size: 48, weight: .black, design: .monospaced))
                .foregroundColor(campaign.accent.accent)

            Text("per 1,000 views")
                .font(.cnBody())
                .foregroundColor(.cnMuted)

            StatusBadge(status: campaign.status)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(campaign.accent.accent.opacity(0.3), lineWidth: 1.5)
        )
    }

    // MARK: - Info Grid
    private var infoGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 10
        ) {
            ApplyInfoTile(label: "Total Views", value: campaign.totalViews.shortFormatted, icon: "eye.fill", color: .cnTeal)
            ApplyInfoTile(label: "Clippers", value: "\(campaign.clippersCount)", icon: "person.2.fill", color: .cnPurple)
            ApplyInfoTile(label: "Min. Payout Views", value: campaign.minimumPayoutViews.shortFormatted, icon: "chart.line.uptrend.xyaxis", color: .cnBlue)
            ApplyInfoTile(label: "Budget Used", value: "\(Int(campaign.capFraction * 100))%", icon: "dollarsign.circle.fill", color: campaign.capFraction > 0.8 ? .cnDanger : .cnAmber)
        }
    }

    // MARK: - Requirements
    private var requirementsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Requirements", systemImage: "checkmark.shield.fill")
                .font(.cnSubhead())
                .foregroundColor(.cnNavy)

            RequirementRow(icon: "watermark", text: "Include campaign overlay/watermark on all clips")
            RequirementRow(icon: "tag.fill", text: "#ad disclosure tag required on every submission")
            RequirementRow(icon: "person.crop.circle.badge.checkmark", text: "Account must be 90+ days old to qualify")
            RequirementRow(icon: "link", text: "Submit clip URL through ClipNet dashboard only")
        }
        .padding(16)
        .cardStyle()
    }

    // MARK: - Bounty
    private func bountyCard(_ bounty: Bounty) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.cnAmber.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: "star.fill")
                    .foregroundColor(.cnAmber)
                    .font(.system(size: 20))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Bounty Available")
                    .font(.cnSubhead())
                Text("Hit \(bounty.thresholdViews.shortFormatted) views on a single clip and earn \(bounty.payoutAmount.currency) bonus")
                    .font(.cnCaption())
                    .foregroundColor(.cnMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Color(hex: "FFF8ED"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.cnAmber.opacity(0.4), lineWidth: 1)
        )
    }

    // MARK: - Platforms
    private var platformsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("APPROVED PLATFORMS")
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

    // MARK: - Applied Confirmation
    private var appliedConfirmation: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.cnSuccess)
                    .font(.system(size: 22))
                Text("You're in! Download the source material and start clipping.")
                    .font(.cnBody())
                    .foregroundColor(.cnText)
            }
            .padding(16)
            .background(Color(hex: "DCFCE7"))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            NavyButton(title: "Submit a Clip") {}
        }
    }
}

private struct ApplyInfoTile: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16))
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.cnText)
            Text(label)
                .font(.cnCaption())
                .foregroundColor(.cnMuted)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .surfaceStyle()
    }
}

private struct RequirementRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.cnTeal)
                .font(.system(size: 14))
                .padding(.top, 1)
            Text(text)
                .font(.cnBody())
                .foregroundColor(.cnText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
