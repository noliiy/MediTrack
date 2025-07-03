import SwiftUI

struct MedicationCardView: View {
    let medication: Medication
    let onTaken: () -> Void
    @State private var showDetails = false
    @State private var animateCheck = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                // İlaç İkonu
                ZStack {
                    Circle()
                        .fill(Color.theme.primary.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "pills.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color.theme.primary)
                }
                
                // İlaç Bilgileri
                VStack(alignment: .leading, spacing: 8) {
                    Text(medication.name)
                        .font(.title3.bold())
                        .foregroundColor(.theme.text)
                    
                    Text(medication.dosage)
                        .font(.subheadline)
                        .foregroundColor(.theme.secondaryText)
                    
                    HStack(spacing: 8) {
                        Label(
                            medication.intakeCondition.rawValue,
                            systemImage: "clock.fill"
                        )
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.theme.primary.opacity(0.1))
                        .foregroundColor(Color.theme.primary)
                        .cornerRadius(8)
                        
                        ForEach(medication.times) { time in
                            Text("\(time.hour):\(String(format: "%02d", time.minute))")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.theme.secondary.opacity(0.1))
                                .foregroundColor(Color.theme.secondary)
                                .cornerRadius(8)
                        }
                    }
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
                            .fill(Color.theme.primary.opacity(0.1))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.theme.primary)
                            .scaleEffect(animateCheck ? 1.2 : 1.0)
                    }
                }
            }
            .padding()
            
            // Notlar (eğer varsa)
            if let notes = medication.notes {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                        .background(Color.theme.secondary.opacity(0.2))
                    
                    HStack {
                        Image(systemName: "text.quote")
                            .foregroundColor(.theme.secondary)
                        
                        Text(notes)
                            .font(.footnote)
                            .foregroundColor(.theme.secondaryText)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }
        }
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

#Preview {
    MedicationCardView(
        medication: Medication(
            name: "Aspirin",
            dosage: "100mg",
            intakeCondition: .afterMeal,
            frequency: 2,
            times: [
                MedicationTime(hour: 9, minute: 0),
                MedicationTime(hour: 21, minute: 0)
            ],
            notes: "Yemekten 30 dakika sonra alınmalı"
        ),
        onTaken: {}
    )
    .padding()
} 