import SwiftUI

// MARK: - Color Hex Initializer

extension Color {
    /// Creates a `Color` from a hexadecimal string (e.g. "#8FA888" or "8FA888").
    /// Supports 6-digit hex only. Alpha is always 1.0.
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        let scanner = Scanner(string: cleaned)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    /// Creates an adaptive `Color` that automatically resolves to the correct
    /// value for the current light or dark color scheme. This works anywhere
    /// a `Color` is used in SwiftUI -- no `@Environment` or view modifier needed.
    ///
    /// - Parameters:
    ///   - light: The hex color string for light mode (e.g. "#8FA888").
    ///   - dark: The hex color string for dark mode (e.g. "#6B9B78").
    init(light: String, dark: String) {
        #if canImport(UIKit)
        self.init(
            uiColor: UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: Self.component(dark, shift: 16),
                                   green: Self.component(dark, shift: 8),
                                   blue: Self.component(dark, shift: 0),
                                   alpha: 1.0)
                default:
                    return UIColor(red: Self.component(light, shift: 16),
                                   green: Self.component(light, shift: 8),
                                   blue: Self.component(light, shift: 0),
                                   alpha: 1.0)
                }
            }
        )
        #elseif canImport(AppKit)
        self.init(
            nsColor: NSColor(name: nil) { appearance in
                let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                let hex = isDark ? dark : light
                return NSColor(red: Self.component(hex, shift: 16),
                               green: Self.component(hex, shift: 8),
                               blue: Self.component(hex, shift: 0),
                               alpha: 1.0)
            }
        )
        #else
        self.init(hex: light)
        #endif
    }

    /// Parses a hex string and extracts the color component at the given bit shift.
    private static func component(_ hex: String, shift: Int) -> CGFloat {
        let cleaned = hex.replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgbValue)
        let masked = (rgbValue >> shift) & 0xFF
        return CGFloat(masked) / 255.0
    }
}

// MARK: - Theme Color Tokens

/// Centralized theme color tokens for StitchVision.
///
/// All 12 tokens from PRD Addendum A.4. Each token is a static property that
/// returns an adaptive `Color` which automatically resolves to the correct
/// light or dark mode value. No `@Environment` boilerplate is needed in
/// consuming views -- SwiftUI's trait system handles resolution.
///
/// ### Usage inside any SwiftUI view
/// ```swift
/// Text("Hello")
///     .foregroundColor(ThemeColors.textPrimary)
///
/// Rectangle()
///     .fill(ThemeColors.background)
/// ```
///
/// ### Usage with an explicit color scheme (e.g. previews, tests)
/// ```swift
/// ThemeColors.primary(for: .dark)
/// ```
struct ThemeColors {

    // MARK: - Primary Palette

    /// Buttons, active states, progress bars.
    /// Light: #7A9E72 | Dark: #6B9B78
    static let primary = Color(light: "7A9E72", dark: "6B9B78")

    /// Button pressed state.
    /// Light: #6B8D63 | Dark: #5A8A66
    static let primaryPressed = Color(light: "6B8D63", dark: "5A8A66")

    /// Light primary for subtle backgrounds, chips, badges.
    /// Light: #E4EFE1 | Dark: #2A3D28
    static let primaryLight = Color(light: "E4EFE1", dark: "2A3D28")

    /// Deep primary for hero sections, gradient endpoints.
    /// Light: #5C7D55 | Dark: #4A7347
    static let primaryDark = Color(light: "5C7D55", dark: "4A7347")

    // MARK: - Accent Palette

    /// Badges, save tags, error highlights.
    /// Light: #C96D5F | Dark: #E0857A
    static let accent = Color(light: "C96D5F", dark: "E0857A")

    /// Warm gold for highlights, premium features, star ratings.
    /// Light: #C9A96E | Dark: #D4B87A
    static let warmGold = Color(light: "C9A96E", dark: "D4B87A")

    // MARK: - Background & Surfaces

    /// Main app background.
    /// Light: #F9F7F2 | Dark: #141414
    static let background = Color(light: "F9F7F2", dark: "141414")

    /// Cards, modals, sheet surfaces.
    /// Light: #FFFFFF | Dark: #1E1E1E
    static let surface = Color(light: "FFFFFF", dark: "1E1E1E")

    /// Elevated cards.
    /// Light: #F2F0EB | Dark: #2A2A2A
    static let surfaceRaised = Color(light: "F2F0EB", dark: "2A2A2A")

    /// Subtle warm overlay for section backgrounds.
    /// Light: #F3EDE3 | Dark: #1C1C1C
    static let surfaceWarm = Color(light: "F3EDE3", dark: "1C1C1C")

    // MARK: - Gradients

    /// Primary gradient for hero sections and headers.
    static var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [primary, primaryDark],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// Warm background gradient for section headers.
    static var warmGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(light: "F0E8DA", dark: "1E1E1E"),
                Color(light: "F9F7F2", dark: "141414")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Utility

    /// Camera HUD overlay ONLY -- never changes between modes.
    /// Both: #EBFF00
    static let hud = Color(hex: "EBFF00")

    /// Primary body and headline text.
    /// Light: #1F1F1F | Dark: #F0F0F0
    static let textPrimary = Color(light: "1F1F1F", dark: "F0F0F0")

    /// Secondary and caption text.
    /// Light: #6B6B6B | Dark: #A0A0A0
    static let textSecondary = Color(light: "6B6B6B", dark: "A0A0A0")

    /// Card borders and dividers.
    /// Light: #E0DDD6 | Dark: #333333
    static let border = Color(light: "E0DDD6", dark: "333333")

    /// Delete and destructive actions.
    /// Light: #DC2626 | Dark: #FF6B6B
    static let destructive = Color(light: "DC2626", dark: "FF6B6B")

    /// Completion and success states.
    /// Light: #16A34A | Dark: #4ADE80
    static let success = Color(light: "16A34A", dark: "4ADE80")

    // MARK: - Explicit Scheme Resolution

    static func primary(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "7A9E72") : Color(hex: "6B9B78")
    }

    static func primaryPressed(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "6B8D63") : Color(hex: "5A8A66")
    }

    static func primaryLight(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "E4EFE1") : Color(hex: "2A3D28")
    }

    static func primaryDark(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "5C7D55") : Color(hex: "4A7347")
    }

    static func accent(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "C96D5F") : Color(hex: "E0857A")
    }

    static func warmGold(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "C9A96E") : Color(hex: "D4B87A")
    }

    static func background(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "F9F7F2") : Color(hex: "141414")
    }

    static func surface(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "FFFFFF") : Color(hex: "1E1E1E")
    }

    static func surfaceRaised(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "F2F0EB") : Color(hex: "2A2A2A")
    }

    static func surfaceWarm(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "F3EDE3") : Color(hex: "1C1C1C")
    }

    static func textPrimary(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "1F1F1F") : Color(hex: "F0F0F0")
    }

    static func textSecondary(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "6B6B6B") : Color(hex: "A0A0A0")
    }

    static func border(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "E0DDD6") : Color(hex: "333333")
    }

    static func destructive(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "DC2626") : Color(hex: "FF6B6B")
    }

    static func success(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "16A34A") : Color(hex: "4ADE80")
    }
}

// MARK: - Convenience Color Extensions

extension Color {
    static var stitchPrimary: Color { ThemeColors.primary }
    static var stitchPrimaryPressed: Color { ThemeColors.primaryPressed }
    static var stitchPrimaryLight: Color { ThemeColors.primaryLight }
    static var stitchPrimaryDark: Color { ThemeColors.primaryDark }
    static var stitchAccent: Color { ThemeColors.accent }
    static var stitchWarmGold: Color { ThemeColors.warmGold }
    static var stitchBackground: Color { ThemeColors.background }
    static var stitchSurface: Color { ThemeColors.surface }
    static var stitchSurfaceRaised: Color { ThemeColors.surfaceRaised }
    static var stitchSurfaceWarm: Color { ThemeColors.surfaceWarm }
    static var stitchHud: Color { ThemeColors.hud }
    static var stitchTextPrimary: Color { ThemeColors.textPrimary }
    static var stitchTextSecondary: Color { ThemeColors.textSecondary }
    static var stitchBorder: Color { ThemeColors.border }
    static var stitchDestructive: Color { ThemeColors.destructive }
    static var stitchSuccess: Color { ThemeColors.success }
}
