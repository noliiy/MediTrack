import SwiftUI

struct BottomMenuView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 120) {
            TabButton(
                icon: "pills.fill",
                title: "Ana Sayfa",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            TabButton(
                icon: "checkmark.circle.fill",
                title: "Tamamlandı",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }
        }
        .padding(.vertical)
        .background(Color.theme.background)
    }
}

struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .theme.primary : .theme.secondaryText)
        }
    }
}

#Preview {
    BottomMenuView(selectedTab: .constant(0))
} 