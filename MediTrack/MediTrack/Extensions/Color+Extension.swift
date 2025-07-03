import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let primary = Color("PrimaryBlue")
    let secondary = Color("SecondaryBlue")
    let accent = Color("AccentColor")
    let background = Color("Background")
    let cardBackground = Color("CardBackground")
    let text = Color("TextColor")
    let secondaryText = Color("SecondaryText")
    
    // Gradients
    var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [primary.opacity(0.8), primary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var cardGradient: LinearGradient {
        LinearGradient(
            colors: [cardBackground, cardBackground.opacity(0.8)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
} 