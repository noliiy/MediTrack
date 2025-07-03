import SwiftUI

struct MedicationCardView: View {
    let medication: Medication
    let onTaken: () -> Void
    @State private var showDetails = false
    @State private var animateCheck = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(alignment: .center, spacing: 16) {
                // İlaç İkonu
                ZStack {
                    Circle()
                        .fill(Color.theme.primary.opacity(0.1))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "pills.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color.theme.primary)
                }
                
                // İlaç Bilgileri
                VStack(alignment: .leading, spacing: 4) {
                    Text(medication.name)
                        .font(.title3.bold())
                        .foregroundColor(.theme.text)
                    
                    Text(medication.dosage)
                        .font(.subheadline)
                        .foregroundColor(.theme.secondaryText)
                }
                
                Spacer()
                
                // Alındı Butonu
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        animateCheck = true
                        onTaken()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            animateCheck = false
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.theme.success.opacity(0.1))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.theme.success)
                            .scaleEffect(animateCheck ? 1.2 : 1.0)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            // Divider
            Rectangle()
                .fill(Color.theme.secondaryBackground)
                .frame(height: 1)
                .padding(.horizontal, 20)
            
            // Details
            VStack(spacing: 12) {
                // Alım Zamanları
                HStack(spacing: 8) {
                    ForEach(medication.times) { time in
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 12))
                            Text("\(time.hour):\(String(format: "%02d", time.minute))")
                                .font(.system(.caption, design: .rounded))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.theme.primary.opacity(0.1))
                        .foregroundColor(Color.theme.primary)
                        .cornerRadius(12)
                    }
                }
                
                // Alım Koşulu
                HStack(spacing: 4) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 12))
                    Text(medication.intakeCondition.rawValue)
                        .font(.system(.caption, design: .rounded))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.theme.secondary.opacity(0.1))
                .foregroundColor(Color.theme.secondary)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            // Notlar (eğer varsa)
            if let notes = medication.notes {
                VStack(alignment: .leading, spacing: 8) {
                    Rectangle()
                        .fill(Color.theme.secondaryBackground)
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "text.quote")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.theme.secondary)
                        
                        Text(notes)
                            .font(.system(.footnote))
                            .foregroundColor(.theme.secondaryText)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(Color.theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.theme.shadowColor, radius: 15, x: 0, y: 5)
        .padding(.horizontal)
    }
}

#Preview {
    MedicationCardView(
        medication: Medication(
            name: "Aspirin",
            dosage: "100mg",
            intakeCondition: .afterMeal,
            frequency: 1,
            times: [MedicationTime(hour: 9, minute: 0)],
            notes: "Yemekten 30 dakika sonra alınmalı"
        ),
        onTaken: {}
    )
    .padding(.vertical)
} 
} 