import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    // Main Colors
    let primary = Color(red: 0.45, green: 0.73, blue: 0.98) // Pastel Blue
    let secondary = Color(red: 0.96, green: 0.76, blue: 0.76) // Pastel Pink
    let accent = Color(red: 0.75, green: 0.87, blue: 0.69) // Pastel Green
    
    // Background Colors
    let background = Color(red: 0.96, green: 0.96, blue: 0.98) // Light Gray Blue
    let cardBackground = Color.white
    
    // Text Colors
    let text = Color(red: 0.2, green: 0.2, blue: 0.3)
    let secondaryText = Color(red: 0.5, green: 0.5, blue: 0.6)
    
    // Status Colors
    let success = Color(red: 0.7, green: 0.85, blue: 0.75) // Soft Green
    let warning = Color(red: 0.95, green: 0.85, blue: 0.6) // Soft Yellow
    let error = Color(red: 0.95, green: 0.7, blue: 0.7) // Soft Red
    
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
            colors: [Color.white, Color.white.opacity(0.95)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
} 