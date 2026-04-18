import SwiftUI

// MARK: - Stat Card
struct StatCard: View {
    let label: String
    let value: String
    var accentColor: Color = .cnAmber
    var valueColor: Color = .cnText

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Rectangle()
                .fill(accentColor)
                .frame(height: 3)
                .clipShape(RoundedRectangle(cornerRadius: 2))

            Text(label.uppercased())
                .font(.cnLabel())
                .foregroundColor(.cnMuted)

            Text(value)
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .foregroundColor(valueColor)
        }
        .padding(14)
        .surfaceStyle()
    }
}

// MARK: - Platform Tag
struct PlatformTag: View {
    let platform: Platform
    var compact = false

    var body: some View {
        HStack(spacing: 4) {
            if !compact {
                Image(systemName: platform.sfSymbol)
                    .font(.system(size: 10, weight: .medium))
            }
            Text(compact ? String(platform.rawValue.prefix(2)) : platform.rawValue)
                .font(.cnLabel())
        }
        .padding(.horizontal, compact ? 6 : 8)
        .padding(.vertical, 4)
        .background(Color.cnSurface)
        .foregroundColor(.cnText)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.cnBorder, lineWidth: 0.5)
        )
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let status: CampaignStatus

    var body: some View {
        Text(status.rawValue)
            .font(.cnLabel())
            .foregroundColor(status.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// MARK: - Clip Status Badge
struct ClipStatusBadge: View {
    let status: ClipStatus

    var body: some View {
        Text(status.rawValue)
            .font(.cnLabel())
            .foregroundColor(status.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// MARK: - Creator Avatar
struct CreatorAvatar: View {
    let initials: String
    let accent: AccentSet
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(accent.background)
            Text(initials)
                .font(.system(size: size * 0.32, weight: .bold))
                .foregroundColor(accent.foreground)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Cap Progress Bar
struct CapProgressBar: View {
    let fraction: Double
    var height: CGFloat = 4

    var barColor: Color {
        fraction >= 1.0 ? .cnDanger : .cnAmber
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.cnBorder)
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(barColor)
                    .frame(width: geo.size.width * CGFloat(fraction))
                    .animation(.easeOut(duration: 0.5), value: fraction)
            }
        }
        .frame(height: height)
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var action: (() -> Void)? = nil
    var actionLabel: String = "See all"

    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.cnLabel())
                .foregroundColor(.cnMuted)
            Spacer()
            if let action {
                Button(actionLabel, action: action)
                    .font(.cnCaption())
                    .foregroundColor(.cnAmber)
            }
        }
    }
}

// MARK: - Empty State
struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 40))
                .foregroundColor(.cnMuted)
            Text(title)
                .font(.cnSubhead())
                .foregroundColor(.cnText)
            Text(subtitle)
                .font(.cnBody())
                .foregroundColor(.cnMuted)
                .multilineTextAlignment(.center)
        }
        .padding(32)
    }
}

// MARK: - Navy Button
struct NavyButton: View {
    let title: String
    let action: () -> Void
    var isFullWidth = true

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.cnSubhead())
                .foregroundColor(.white)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding(.vertical, 14)
                .padding(.horizontal, isFullWidth ? 0 : 24)
                .background(Color.cnNavy)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

// MARK: - Amber Button
struct AmberButton: View {
    let title: String
    let action: () -> Void
    var isFullWidth = true

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.cnSubhead())
                .foregroundColor(.cnNavy)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding(.vertical, 14)
                .padding(.horizontal, isFullWidth ? 0 : 24)
                .background(Color.cnAmber)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

// MARK: - Labeled Field
struct LabeledField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.cnLabel())
                .foregroundColor(.cnMuted)
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(12)
                .background(Color.cnSurface)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.cnBorder, lineWidth: 0.5)
                )
        }
    }
}
