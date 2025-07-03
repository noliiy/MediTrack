import SwiftUI

struct BottomMenuView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 120) {
            Button(action: { selectedTab = 0 }) {
                VStack(spacing: 8) {
                    Image(systemName: "pills.fill")
                        .font(.system(size: 24))
                    Text("Ana Sayfa")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 0 ? .theme.primary : .theme.secondaryText)
            }
            
            Button(action: { selectedTab = 1 }) {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                    Text("Tamamlandı")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 1 ? .theme.primary : .theme.secondaryText)
            }
        }
        .padding(.vertical)
        .background(Color.theme.background)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedTab = 0
        
        var body: some View {
            BottomMenuView(selectedTab: $selectedTab)
        }
    }
    
    return PreviewWrapper()
} 