import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let mainBlue = Color(red: 0.4, green: 0.6, blue: 1.0) // Açık mavi
    let background = Color.white
    let text = Color.black
    let secondaryText = Color.gray
    let cardBackground = Color(white: 0.97) // Çok açık gri
} 