import SwiftUI

struct BottomMenuView: View {
    var body: some View {
        HStack(spacing: 120) {
            VStack(spacing: 8) {
                Image(systemName: "pills.fill")
                    .font(.system(size: 24))
                Text("Ana Sayfa")
                    .font(.caption)
            }
            .foregroundColor(.theme.primary)
            
            VStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                Text("Tamamlandı")
                    .font(.caption)
            }
            .foregroundColor(.theme.primary)
        }
        .padding(.vertical)
        .background(Color.theme.background)
    }
}

#Preview {
    BottomMenuView()
        .previewLayout(.sizeThatFits)
} 