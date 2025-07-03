import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let primary = Color("PrimaryBlue")
    let secondary = Color("SecondaryBlue")
    let background = Color("Background")
    let text = Color("TextColor")
    let accent = Color("AccentColor")
} 