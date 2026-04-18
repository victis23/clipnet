import SwiftUI

struct CreateCampaignView: View {
    @EnvironmentObject var vm: AppViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var form = NewCampaignForm()
    @State private var showBountySection = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Creator name
                    LabeledField(
                        label: "Creator / Brand Name",
                        placeholder: "e.g. Caleb Hammer",
                        text: $form.creatorName
                    )

                    // CPM + Cap row
                    HStack(spacing: 12) {
                        LabeledField(
                            label: "CPM Rate ($)",
                            placeholder: "0.75",
                            text: $form.cpmRate,
                            keyboardType: .decimalPad
                        )
                        LabeledField(
                            label: "Campaign Cap ($)",
                            placeholder: "10,000",
                            text: $form.campaignCap,
                            keyboardType: .numberPad
                        )
                    }

                    // Min payout views
                    LabeledField(
                        label: "Min. Payout Views",
                        placeholder: "100000",
                        text: $form.minimumPayoutViews,
                        keyboardType: .numberPad
                    )

                    // Platforms
                    VStack(alignment: .leading, spacing: 10) {
                        Text("PLATFORMS")
                            .font(.cnLabel())
                            .foregroundColor(.cnMuted)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            ForEach(Platform.allCases) { platform in
                                PlatformToggle(
                                    platform: platform,
                                    isSelected: form.selectedPlatforms.contains(platform)
                                ) {
                                    if form.selectedPlatforms.contains(platform) {
                                        form.selectedPlatforms.remove(platform)
                                    } else {
                                        form.selectedPlatforms.insert(platform)
                                    }
                                }
                            }
                        }
                    }

                    // Bounty toggle
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Add Bounty")
                                    .font(.cnSubhead())
                                Text("Optional one-time reward at view threshold")
                                    .font(.cnCaption())
                                    .foregroundColor(.cnMuted)
                            }
                            Spacer()
                            Toggle("", isOn: $showBountySection)
                                .tint(.cnAmber)
                        }
                        .padding(16)

                        if showBountySection {
                            Divider().padding(.horizontal, 16)
                            HStack(spacing: 12) {
                                LabeledField(
                                    label: "Trigger Views",
                                    placeholder: "1,000,000",
                                    text: $form.bountyThresholdViews,
                                    keyboardType: .numberPad
                                )
                                LabeledField(
                                    label: "Bounty Payout ($)",
                                    placeholder: "3,000",
                                    text: $form.bountyPayoutAmount,
                                    keyboardType: .numberPad
                                )
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                        }
                    }
                    .background(Color.cnSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.cnBorder, lineWidth: 0.5)
                    )

                    // FTC notice
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "shield.checkered")
                            .foregroundColor(.cnTeal)
                            .font(.system(size: 16))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("FTC Compliant")
                                .font(.cnCaption().bold())
                                .foregroundColor(.cnTeal)
                            Text("All clips in this campaign will automatically include an #ad disclosure tag.")
                                .font(.cnCaption())
                                .foregroundColor(.cnMuted)
                        }
                    }
                    .padding(14)
                    .background(Color(hex: "EDFAF8"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    // Launch button
                    AmberButton(title: "Launch Campaign") {
                        vm.createCampaign(from: form)
                    }
                    .disabled(!form.isValid)
                    .opacity(form.isValid ? 1.0 : 0.5)
                }
                .padding(20)
                .padding(.bottom, 32)
            }
            .background(Color.cnSurface.ignoresSafeArea())
            .navigationTitle("New Campaign")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.cnMuted)
                }
            }
        }
    }
}

// MARK: - Platform Toggle Button
private struct PlatformToggle: View {
    let platform: Platform
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: platform.sfSymbol)
                    .font(.system(size: 13, weight: .medium))
                Text(platform.rawValue)
                    .font(.cnBody())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 11)
            .foregroundColor(isSelected ? .cnNavy : .cnText)
            .background(isSelected ? Color.cnAmber : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.cnAmber : Color.cnBorder, lineWidth: isSelected ? 1.5 : 0.5)
            )
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
