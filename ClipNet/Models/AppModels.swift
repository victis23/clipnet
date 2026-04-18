import Foundation
import SwiftUI

// MARK: - Role
enum AppRole: String, CaseIterable, RawRepresentable {
    case brand   = "Brand"
    case clipper = "Clipper"
}

// MARK: - Platform
enum Platform: String, CaseIterable, Identifiable, Codable {
    case tiktok    = "TikTok"
    case instagram = "Instagram"
    case youtube   = "YouTube"
    case x         = "X"

    var id: String { rawValue }

    var sfSymbol: String {
        switch self {
        case .tiktok:    return "music.note"
        case .instagram: return "camera.circle"
        case .youtube:   return "play.rectangle.fill"
        case .x:         return "xmark.circle.fill"
        }
    }
}

// MARK: - Campaign Status
enum CampaignStatus: String, CaseIterable {
    case active = "Active"
    case capped = "Capped"
    case paused = "Paused"
    case ended  = "Ended"

    var color: Color {
        switch self {
        case .active: return .cnSuccess
        case .capped: return .cnDanger
        case .paused: return .cnAmber
        case .ended:  return .cnMuted
        }
    }

    var bgColor: Color {
        switch self {
        case .active: return Color(hex: "DCFCE7")
        case .capped: return Color(hex: "FEE2E2")
        case .paused: return Color(hex: "FEF9C3")
        case .ended:  return Color(hex: "F3F4F6")
        }
    }
}

// MARK: - Bounty
struct Bounty: Identifiable, Equatable {
    let id = UUID()
    var thresholdViews: Int
    var payoutAmount: Double

	static func ==(lhs: Bounty, rhs: Bounty) -> Bool {
		return lhs.id == rhs.id &&
		lhs.thresholdViews == rhs.thresholdViews &&
		lhs.payoutAmount == rhs.payoutAmount
	}
}

// MARK: - Campaign
struct Campaign: Identifiable {
    let id: UUID
    var creatorName: String
    var cpmRate: Double
    var platforms: [Platform]
    var totalViews: Int
    var clippersCount: Int
    var clipsCount: Int
    var paidOut: Double
    var campaignCap: Double
    var minimumPayoutViews: Int
    var status: CampaignStatus
    var bounty: Bounty?
    var accentIndex: Int

    var accent: AccentSet { AccentSet.all[accentIndex % AccentSet.all.count] }

    var capFraction: Double {
        guard campaignCap > 0 else { return 0 }
        return min(paidOut / campaignCap, 1.0)
    }

    var initials: String {
        creatorName
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first.map(String.init) }
            .joined()
            .uppercased()
    }
}

extension Campaign: Hashable, Equatable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	static func ==(lhs: Campaign, rhs: Campaign) -> Bool {
		lhs.id == rhs.id &&
		lhs.creatorName == rhs.creatorName &&
		lhs.cpmRate == rhs.cpmRate &&
		lhs.platforms == rhs.platforms &&
		lhs.totalViews == rhs.totalViews &&
		lhs.clippersCount == rhs.clippersCount &&
		lhs.clipsCount == rhs.clipsCount &&
		lhs.paidOut == rhs.paidOut &&
		lhs.campaignCap == rhs.campaignCap &&
		lhs.minimumPayoutViews == rhs.minimumPayoutViews &&
		lhs.status == rhs.status &&
		lhs.bounty == rhs.bounty &&
		lhs.accentIndex == rhs.accentIndex
	}
}

// MARK: - Clip Status
enum ClipStatus: String, CaseIterable {
    case pending  = "Pending"
    case verified = "Verified"
    case paid     = "Paid"
    case rejected = "Rejected"

    var color: Color {
        switch self {
        case .pending:  return .cnAmber
        case .verified: return .cnTeal
        case .paid:     return .cnSuccess
        case .rejected: return .cnDanger
        }
    }

    var bgColor: Color {
        switch self {
        case .pending:  return Color(hex: "FEF9C3")
        case .verified: return Color(hex: "CCFBF1")
        case .paid:     return Color(hex: "DCFCE7")
        case .rejected: return Color(hex: "FEE2E2")
        }
    }
}

// MARK: - Clip Submission
struct ClipSubmission: Identifiable {
    let id: UUID
    var campaignId: UUID
    var creatorName: String
    var platform: Platform
    var clipURL: String
    var views: Int
    var earnedAmount: Double
    var status: ClipStatus
    var submittedAt: Date
}

// MARK: - New Campaign Form
struct NewCampaignForm {
    var creatorName: String = ""
    var cpmRate: String = ""
    var campaignCap: String = ""
    var minimumPayoutViews: String = "100000"
    var selectedPlatforms: Set<Platform> = []
    var bountyThresholdViews: String = ""
    var bountyPayoutAmount: String = ""

    var isValid: Bool {
        !creatorName.isEmpty &&
        Double(cpmRate) != nil &&
        !selectedPlatforms.isEmpty
    }
}
