import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    // Main Colors
    let primary = Color(red: 0.32, green: 0.59, blue: 0.89) // Modern Blue
    let secondary = Color(red: 0.95, green: 0.61, blue: 0.07) // Warm Orange
    let accent = Color(red: 0.18, green: 0.80, blue: 0.44) // Fresh Green
    
    // Background Colors
    let background = Color(red: 0.98, green: 0.98, blue: 0.98) // Light Gray
    let cardBackground = Color.white
    let secondaryBackground = Color(red: 0.96, green: 0.96, blue: 0.96) // Slightly Darker Gray
    
    // Text Colors
    let text = Color(red: 0.13, green: 0.18, blue: 0.24) // Dark Blue Gray
    let secondaryText = Color(red: 0.50, green: 0.55, blue: 0.60) // Medium Gray
    
    // Status Colors
    let success = Color(red: 0.18, green: 0.80, blue: 0.44) // Green
    let warning = Color(red: 0.95, green: 0.61, blue: 0.07) // Orange
    let error = Color(red: 0.89, green: 0.21, blue: 0.21) // Red
    
    // Gradients
    var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.32, green: 0.59, blue: 0.89),
                Color(red: 0.24, green: 0.54, blue: 0.87)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var cardGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white,
                Color(red: 0.98, green: 0.98, blue: 0.98)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // Shadows
    var shadowColor: Color {
        Color.black.opacity(0.1)
    }
    
    var lightShadow: Color {
        Color.white.opacity(0.9)
    }
} 