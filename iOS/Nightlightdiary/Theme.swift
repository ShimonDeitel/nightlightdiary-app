import SwiftUI

/// Bespoke palette + type for Nightlight Diary - Sleep Environment Log.
enum Theme {
    static let background = Color(hex: "#0D1B24")
    static let primary = Color(hex: "#1B3A4B")
    static let secondary = Color(hex: "#4A7A96")
    static let accent = Color(hex: "#F4D35E")
    static let cardBackground = Color(hex: "#0D1B24").opacity(0.6)

    static let titleFont = Font.custom("Helvetica Neue", size: 28).weight(.bold)
    static let headlineFont = Font.custom("Helvetica Neue", size: 18).weight(.semibold)
    static let bodyFont = Font.custom("Helvetica Neue", size: 16)
    static let captionFont = Font.custom("Helvetica Neue", size: 13)
}

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
