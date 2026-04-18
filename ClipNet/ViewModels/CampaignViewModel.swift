import Foundation
import SwiftUI
import Combine

@MainActor
final class CampaignViewModel: ObservableObject {
    // MARK: - State
    @Published var campaigns: [Campaign] = []
    
    @Published var isShowingCreateCampaign = false

    // MARK: - Computed Brand Stats
    var totalViews: Int      { campaigns.reduce(0) { $0 + $1.totalViews } }
    var totalPaidOut: Double { campaigns.reduce(0) { $0 + $1.paidOut } }
    var activeCampaigns: Int { campaigns.filter { $0.status == .active }.count }

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
		let sampleData = SampleData()
		campaigns = sampleData.loadSampleCampaignData()
    }
}
