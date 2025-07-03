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
                withAnimation {
                    selectedTab = 0
                }
            }
            
            TabButton(
                icon: "checkmark.circle.fill",
                title: "Tamamlandı",
                isSelected: selectedTab == 1
            ) {
                withAnimation {
                    selectedTab = 1
                }
            }
        }
        .padding(.vertical)
        .background(Color.theme.cardBackground)
    }
}

private struct TabButton: View {
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
        .previewLayout(.sizeThatFits)
} 