import Foundation
import SwiftUI
import Combine

@MainActor
final class AppViewModel: ObservableObject {
    // MARK: - State
    @Published var campaigns: [Campaign] = []
    @Published var myClips: [ClipSubmission] = []
    @Published var isShowingCreateCampaign = false

    // MARK: - Computed Brand Stats
    var totalViews: Int      { campaigns.reduce(0) { $0 + $1.totalViews } }
    var totalPaidOut: Double { campaigns.reduce(0) { $0 + $1.paidOut } }
    var activeCampaigns: Int { campaigns.filter { $0.status == .active }.count }

    // MARK: - Computed Clipper Stats
    var totalEarned: Double   { myClips.reduce(0) { $0 + $1.earnedAmount } }
    var pendingEarnings: Double {
        myClips.filter { $0.status == .pending || $0.status == .verified }
               .reduce(0) { $0 + $1.earnedAmount }
    }
    var openCampaigns: Int { campaigns.filter { $0.status == .active }.count }

    // MARK: - Init
    init() {
        loadSampleData()
    }

    // MARK: - Create Campaign
    func createCampaign(from form: NewCampaignForm) {
        guard form.isValid else { return }
        let cpm  = Double(form.cpmRate) ?? 0
        let cap  = Double(form.campaignCap) ?? 10_000
        let minV = Int(form.minimumPayoutViews) ?? 100_000
        let bt   = Int(form.bountyThresholdViews) ?? 0
        let bp   = Double(form.bountyPayoutAmount) ?? 0

        let bounty: Bounty? = bt > 0 && bp > 0 ? Bounty(thresholdViews: bt, payoutAmount: bp) : nil

        let new = Campaign(
            id: UUID(),
            creatorName: form.creatorName,
            cpmRate: cpm,
            platforms: Array(form.selectedPlatforms),
            totalViews: 0,
            clippersCount: 0,
            clipsCount: 0,
            paidOut: 0,
            campaignCap: cap,
            minimumPayoutViews: minV,
            status: .active,
            bounty: bounty,
            accentIndex: campaigns.count % AccentSet.all.count
        )
        campaigns.insert(new, at: 0)
        isShowingCreateCampaign = false
    }

    // MARK: - Sample Data
    private func loadSampleData() {
        campaigns = [
            Campaign(
                id: UUID(), creatorName: "Caleb Hammer",
                cpmRate: 0.75, platforms: [.tiktok, .instagram, .x],
                totalViews: 847_200_000, clippersCount: 312, clipsCount: 4200,
                paidOut: 8_420, campaignCap: 15_000, minimumPayoutViews: 100_000,
                status: .active, bounty: nil, accentIndex: 0
            ),
            Campaign(
                id: UUID(), creatorName: "Pirate Software",
                cpmRate: 3.00, platforms: [.tiktok, .instagram, .youtube, .x],
                totalViews: 124_000_000, clippersCount: 89, clipsCount: 720,
                paidOut: 3_200, campaignCap: 10_000, minimumPayoutViews: 100_000,
                status: .active,
                bounty: Bounty(thresholdViews: 1_000_000, payoutAmount: 3_000),
                accentIndex: 4
            ),
            Campaign(
                id: UUID(), creatorName: "Clavicular",
                cpmRate: 1.20, platforms: [.tiktok, .instagram, .youtube],
                totalViews: 2_200_000_000, clippersCount: 1610, clipsCount: 69_000,
                paidOut: 20_000, campaignCap: 20_000, minimumPayoutViews: 100_000,
                status: .capped, bounty: nil, accentIndex: 2
            ),
            Campaign(
                id: UUID(), creatorName: "Aiden Ross",
                cpmRate: 0.85, platforms: [.tiktok, .instagram],
                totalViews: 714_000_000, clippersCount: 812, clipsCount: 11_000,
                paidOut: 7_800, campaignCap: 12_000, minimumPayoutViews: 100_000,
                status: .active, bounty: nil, accentIndex: 3
            ),
            Campaign(
                id: UUID(), creatorName: "Asmon Gold",
                cpmRate: 0.60, platforms: [.youtube, .tiktok, .x],
                totalViews: 320_000_000, clippersCount: 66, clipsCount: 2000,
                paidOut: 2_100, campaignCap: 8_000, minimumPayoutViews: 100_000,
                status: .active, bounty: nil, accentIndex: 1
            ),
        ]

        let caleb = campaigns[0]
        let aiden = campaigns[3]
        let pirate = campaigns[1]

        myClips = [
            ClipSubmission(
                id: UUID(), campaignId: caleb.id, creatorName: "Caleb Hammer",
                platform: .tiktok, clipURL: "https://tiktok.com/@clipper/video/1",
                views: 142_000, earnedAmount: 106.50, status: .paid,
                submittedAt: Date().addingTimeInterval(-86400 * 3)
            ),
            ClipSubmission(
                id: UUID(), campaignId: caleb.id, creatorName: "Caleb Hammer",
                platform: .instagram, clipURL: "https://instagram.com/reel/abc",
                views: 87_000, earnedAmount: 65.25, status: .paid,
                submittedAt: Date().addingTimeInterval(-86400 * 2)
            ),
            ClipSubmission(
                id: UUID(), campaignId: aiden.id, creatorName: "Aiden Ross",
                platform: .tiktok, clipURL: "https://tiktok.com/@clipper/video/2",
                views: 210_000, earnedAmount: 178.50, status: .pending,
                submittedAt: Date().addingTimeInterval(-86400)
            ),
            ClipSubmission(
                id: UUID(), campaignId: pirate.id, creatorName: "Pirate Software",
                platform: .youtube, clipURL: "https://youtube.com/shorts/xyz",
                views: 45_000, earnedAmount: 135.00, status: .verified,
                submittedAt: Date().addingTimeInterval(-3600 * 6)
            ),
        ]
    }
}
