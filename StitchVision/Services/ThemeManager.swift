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

    // MARK: - Adaptive Tokens (auto-resolve from system appearance)

    /// Buttons, active states, progress bars.
    /// Light: #8FA888 | Dark: #6B9B78
    static let primary = Color(light: "8FA888", dark: "6B9B78")

    /// Button pressed state.
    /// Light: #7D9176 | Dark: #5A8A66
    static let primaryPressed = Color(light: "7D9176", dark: "5A8A66")

    /// Badges, save tags, error highlights.
    /// Light: #C96D5F | Dark: #E0857A
    static let accent = Color(light: "C96D5F", dark: "E0857A")

    /// Main app background.
    /// Light: #F9F7F2 | Dark: #1A1A1A
    static let background = Color(light: "F9F7F2", dark: "1A1A1A")

    /// Cards, modals, sheet surfaces.
    /// Light: #FFFFFF | Dark: #2C2C2C
    static let surface = Color(light: "FFFFFF", dark: "2C2C2C")

    /// Elevated cards.
    /// Light: #F2F0EB | Dark: #383838
    static let surfaceRaised = Color(light: "F2F0EB", dark: "383838")

    /// Camera HUD overlay ONLY -- never changes between modes.
    /// Both: #EBFF00
    static let hud = Color(hex: "EBFF00")

    /// Primary body and headline text.
    /// Light: #2C2C2C | Dark: #F0F0F0
    static let textPrimary = Color(light: "2C2C2C", dark: "F0F0F0")

    /// Secondary and caption text.
    /// Light: #666666 | Dark: #A0A0A0
    static let textSecondary = Color(light: "666666", dark: "A0A0A0")

    /// Card borders and dividers.
    /// Light: #E0DDD6 | Dark: #3A3A3A
    static let border = Color(light: "E0DDD6", dark: "3A3A3A")

    /// Delete and destructive actions.
    /// Light: #DC2626 | Dark: #FF6B6B
    static let destructive = Color(light: "DC2626", dark: "FF6B6B")

    /// Completion and success states.
    /// Light: #16A34A | Dark: #4ADE80
    static let success = Color(light: "16A34A", dark: "4ADE80")

    // MARK: - Explicit Scheme Resolution

    /// Returns the primary color for an explicit color scheme.
    static func primary(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "8FA888") : Color(hex: "6B9B78")
    }

    /// Returns the primaryPressed color for an explicit color scheme.
    static func primaryPressed(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "7D9176") : Color(hex: "5A8A66")
    }

    /// Returns the accent color for an explicit color scheme.
    static func accent(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "C96D5F") : Color(hex: "E0857A")
    }

    /// Returns the background color for an explicit color scheme.
    static func background(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "F9F7F2") : Color(hex: "1A1A1A")
    }

    /// Returns the surface color for an explicit color scheme.
    static func surface(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "FFFFFF") : Color(hex: "2C2C2C")
    }

    /// Returns the surfaceRaised color for an explicit color scheme.
    static func surfaceRaised(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "F2F0EB") : Color(hex: "383838")
    }

    /// Returns the textPrimary color for an explicit color scheme.
    static func textPrimary(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "2C2C2C") : Color(hex: "F0F0F0")
    }

    /// Returns the textSecondary color for an explicit color scheme.
    static func textSecondary(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "666666") : Color(hex: "A0A0A0")
    }

    /// Returns the border color for an explicit color scheme.
    static func border(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "E0DDD6") : Color(hex: "3A3A3A")
    }

    /// Returns the destructive color for an explicit color scheme.
    static func destructive(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "DC2626") : Color(hex: "FF6B6B")
    }

    /// Returns the success color for an explicit color scheme.
    static func success(for scheme: ColorScheme) -> Color {
        scheme == .light ? Color(hex: "16A34A") : Color(hex: "4ADE80")
    }
}

// MARK: - Convenience Color Extensions

extension Color {
    /// StitchVision primary brand color. Automatically adapts to light/dark mode.
    static var stitchPrimary: Color { ThemeColors.primary }

    /// StitchVision primary pressed state color.
    static var stitchPrimaryPressed: Color { ThemeColors.primaryPressed }

    /// StitchVision accent color for badges and highlights.
    static var stitchAccent: Color { ThemeColors.accent }

    /// StitchVision main app background.
    static var stitchBackground: Color { ThemeColors.background }

    /// StitchVision card and modal surface color.
    static var stitchSurface: Color { ThemeColors.surface }

    /// StitchVision elevated surface color.
    static var stitchSurfaceRaised: Color { ThemeColors.surfaceRaised }

    /// StitchVision camera HUD overlay color. Never changes between modes.
    static var stitchHud: Color { ThemeColors.hud }

    /// StitchVision primary text color.
    static var stitchTextPrimary: Color { ThemeColors.textPrimary }

    /// StitchVision secondary and caption text color.
    static var stitchTextSecondary: Color { ThemeColors.textSecondary }

    /// StitchVision border and divider color.
    static var stitchBorder: Color { ThemeColors.border }

    /// StitchVision destructive action color.
    static var stitchDestructive: Color { ThemeColors.destructive }

    /// StitchVision success and completion state color.
    static var stitchSuccess: Color { ThemeColors.success }
}
