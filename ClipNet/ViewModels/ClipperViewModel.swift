//
//  ClipperViewModel.swift
//  ClipNet
//
//  Created by Scott Leonard on 4/18/26.
//

import Foundation
import SwiftUI
import Combine

final class ClipperViewModel: ObservableObject {
	@Published var myClips: [ClipSubmission] = []

	// MARK: - Computed Clipper Stats
	var totalEarned: Double   { myClips.reduce(0) { $0 + $1.earnedAmount } }
	var pendingEarnings: Double {
		myClips.filter { $0.status == .pending || $0.status == .verified }
			.reduce(0) { $0 + $1.earnedAmount }
	}

	init() {
		loadSampleData()
	}

	// MARK: - Sample Data
	private func loadSampleData() {
		let sampleData = SampleData()
		myClips = sampleData.loadSampleClipData()
	}
}
