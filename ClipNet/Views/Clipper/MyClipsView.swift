import SwiftUI

struct MyClipsView: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var isShowingSubmit = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Quick stats
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 10
                    ) {
                        StatCard(label: "Total Clips", value: "\(vm.myClips.count)", accentColor: .cnTeal)
                        StatCard(label: "Total Views", value: totalClipViews.shortFormatted, accentColor: .cnAmber)
                    }
                    .padding(.horizontal, 20)

                    // Clip list
                    VStack(spacing: 12) {
                        SectionHeader(title: "Recent Submissions")
                            .padding(.horizontal, 20)

                        if vm.myClips.isEmpty {
                            EmptyStateView(
                                systemImage: "scissors",
                                title: "No clips yet",
                                subtitle: "Apply to a campaign and submit your first clip."
                            )
                        } else {
                            LazyVStack(spacing: 10) {
                                ForEach(vm.myClips) { clip in
                                    ClipRow(clip: clip)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color.cnSurface.ignoresSafeArea())
            .navigationTitle("My Clips")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingSubmit = true
                    } label: {
                        Label("Submit Clip", systemImage: "plus")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.cnTeal)
                    }
                }
            }
            .sheet(isPresented: $isShowingSubmit) {
                SubmitClipView()
            }
        }
    }

    private var totalClipViews: Int {
        vm.myClips.reduce(0) { $0 + $1.views }
    }
}

// MARK: - Clip Row
private struct ClipRow: View {
    let clip: ClipSubmission

    var body: some View {
        HStack(spacing: 14) {
            // Platform icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.cnSurface)
                    .frame(width: 42, height: 42)
                Image(systemName: clip.platform.sfSymbol)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.cnNavy)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(clip.creatorName)
                    .font(.cnSubhead())
                HStack(spacing: 6) {
                    Text(clip.platform.rawValue)
                        .font(.cnCaption())
                        .foregroundColor(.cnMuted)
                    Text("·")
                        .foregroundColor(.cnMuted)
                    Text(clip.views.shortFormatted + " views")
                        .font(.cnCaption())
                        .foregroundColor(.cnMuted)
                }
            }

            Spacer()

            // Earnings + status
            VStack(alignment: .trailing, spacing: 4) {
                Text(clip.earnedAmount.currency)
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                    .foregroundColor(.cnText)
                ClipStatusBadge(status: clip.status)
            }
        }
        .padding(14)
        .cardStyle()
    }
}

// MARK: - Submit Clip Sheet (minimal)
private struct SubmitClipView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm: AppViewModel

    @State private var clipURL = ""
    @State private var selectedCampaignId: UUID? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                LabeledField(label: "Clip URL", placeholder: "https://tiktok.com/@you/video/...", text: $clipURL)

                VStack(alignment: .leading, spacing: 8) {
                    Text("CAMPAIGN")
                        .font(.cnLabel())
                        .foregroundColor(.cnMuted)

                    ForEach(vm.campaigns.filter { $0.status == .active }) { c in
                        Button {
                            selectedCampaignId = c.id
                        } label: {
                            HStack {
                                CreatorAvatar(initials: c.initials, accent: c.accent, size: 32)
                                Text(c.creatorName).font(.cnBody())
                                Spacer()
                                if selectedCampaignId == c.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.cnTeal)
                                }
                            }
                            .padding(12)
                            .background(selectedCampaignId == c.id ? Color(hex: "EDFAF8") : Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedCampaignId == c.id ? Color.cnTeal : Color.cnBorder, lineWidth: 0.5)
                            )
                        }
                        .foregroundColor(.cnText)
                    }
                }

                // FTC notice
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill").foregroundColor(.cnTeal)
                    Text("By submitting, you confirm your clip includes the required #ad disclosure.")
                        .font(.cnCaption())
                        .foregroundColor(.cnMuted)
                }
                .padding(12)
                .background(Color(hex: "EDFAF8"))
                .clipShape(RoundedRectangle(cornerRadius: 8))

                NavyButton(title: "Submit Clip") { dismiss() }
                    .disabled(clipURL.isEmpty || selectedCampaignId == nil)
                    .opacity(clipURL.isEmpty || selectedCampaignId == nil ? 0.5 : 1.0)

                Spacer()
            }
            .padding(20)
            .background(Color.cnSurface.ignoresSafeArea())
            .navigationTitle("Submit Clip")
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
