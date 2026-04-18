import SwiftUI

// MARK: - Brand Colors
extension Color {
    static let cnNavy    = Color(hex: "0A1628")
    static let cnAmber   = Color(hex: "F5A623")
    static let cnTeal    = Color(hex: "10B9A7")
    static let cnSurface = Color(hex: "F8F9FA")
    static let cnBorder  = Color(hex: "E5E7EB")
    static let cnMuted   = Color(hex: "9CA3AF")
    static let cnText    = Color(hex: "1F2937")
    static let cnSuccess = Color(hex: "22C55E")
    static let cnDanger  = Color(hex: "EF4444")
    static let cnPurple  = Color(hex: "8B5CF6")
    static let cnBlue    = Color(hex: "3B82F6")
    static let cnPink    = Color(hex: "EC4899")

    init(hex: String) {
        let h = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Accent Color Set
struct AccentSet {
    let background: Color
    let foreground: Color
    let accent: Color
}

extension AccentSet {
    static let amber  = AccentSet(background: Color(hex: "FAEEDA"), foreground: Color(hex: "412402"), accent: .cnAmber)
    static let teal   = AccentSet(background: Color(hex: "E1F5EE"), foreground: Color(hex: "04342C"), accent: .cnTeal)
    static let purple = AccentSet(background: Color(hex: "EEEDFE"), foreground: Color(hex: "26215C"), accent: .cnPurple)
    static let pink   = AccentSet(background: Color(hex: "FBEAF0"), foreground: Color(hex: "4B1528"), accent: .cnPink)
    static let blue   = AccentSet(background: Color(hex: "E6F1FB"), foreground: Color(hex: "042C53"), accent: .cnBlue)

    static let all: [AccentSet] = [.amber, .teal, .purple, .pink, .blue]
}

// MARK: - Typography
extension Font {
    static func cnTitle()   -> Font { .system(size: 28, weight: .bold) }
    static func cnHeading() -> Font { .system(size: 20, weight: .semibold) }
    static func cnSubhead() -> Font { .system(size: 15, weight: .semibold) }
    static func cnBody()    -> Font { .system(size: 14, weight: .regular) }
    static func cnCaption() -> Font { .system(size: 12, weight: .regular) }
    static func cnLabel()   -> Font { .system(size: 10, weight: .semibold) }
    static func cnMono()    -> Font { .system(size: 13, weight: .medium, design: .monospaced) }
}

// MARK: - Number Formatting
extension Int {
    var shortFormatted: String {
        if self >= 1_000_000_000 { return String(format: "%.1fB", Double(self) / 1_000_000_000) }
        if self >= 1_000_000     { return String(format: "%.1fM", Double(self) / 1_000_000) }
        if self >= 1_000         { return "\(self / 1000)K" }
        return "\(self)"
    }
}

extension Double {
    var currency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }

    var shortCurrency: String {
        if self >= 1_000_000 { return String(format: "$%.1fM", self / 1_000_000) }
        if self >= 1_000     { return String(format: "$%.1fK", self / 1_000) }
        return currency
    }
}

// MARK: - View Modifiers
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

struct SurfaceStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.cnSurface)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension View {
    func cardStyle() -> some View   { modifier(CardStyle()) }
    func surfaceStyle() -> some View { modifier(SurfaceStyle()) }
}
