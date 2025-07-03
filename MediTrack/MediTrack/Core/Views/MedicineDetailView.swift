import SwiftUI

struct MedicineDetailView: View {
    let medication: Medication
    @Environment(\.dismiss) private var dismiss
    @State private var showingTimer = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.theme.text)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "star")
                        .font(.title2)
                        .foregroundColor(.theme.warning)
                }
                .padding(.horizontal)
                
                // Medicine Icon
                ZStack {
                    Circle()
                        .fill(Color.theme.primary.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "pills.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.theme.primary)
                }
                .padding(.vertical)
                
                // Medicine Info
                VStack(spacing: 16) {
                    Text(medication.name)
                        .font(.title.bold())
                        .foregroundColor(.theme.text)
                    
                    Text(medication.dosage)
                        .font(.title3)
                        .foregroundColor(.theme.secondaryText)
                }
                
                // Intake Details
                VStack(spacing: 24) {
                    DetailRow(
                        icon: "clock.fill",
                        title: "Intake Times",
                        value: medication.times.map { "\($0.hour):\(String(format: "%02d", $0.minute))" }.joined(separator: ", "),
                        color: .theme.primary
                    )
                    
                    DetailRow(
                        icon: "fork.knife",
                        title: "Intake Condition",
                        value: medication.intakeCondition.rawValue,
                        color: .theme.secondary
                    )
                    
                    DetailRow(
                        icon: "calendar",
                        title: "Frequency",
                        value: "\(medication.frequency) times per day",
                        color: .theme.accent
                    )
                }
                .padding()
                .background(Color.theme.cardBackground)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
                .padding(.horizontal)
                
                if let notes = medication.notes {
                    // Notes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.theme.text)
                        
                        Text(notes)
                            .font(.body)
                            .foregroundColor(.theme.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.theme.cardBackground)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: { showingTimer = true }) {
                        Label("Set Timer", systemImage: "timer")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.theme.primary)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {}) {
                        Label("Edit", systemImage: "pencil")
                            .font(.headline)
                            .foregroundColor(.theme.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.theme.primary.opacity(0.1))
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.theme.background.ignoresSafeArea())
        .sheet(isPresented: $showingTimer) {
            ReminderView(medication: medication)
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.theme.secondaryText)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.theme.text)
            }
            
            Spacer()
        }
    }
}

#Preview {
    MedicineDetailView(medication: Medication(
        name: "Aspirin",
        dosage: "100mg",
        intakeCondition: .afterMeal,
        frequency: 2,
        times: [
            MedicationTime(hour: 9, minute: 0),
            MedicationTime(hour: 21, minute: 0)
        ],
        notes: "Take with water. Avoid taking on empty stomach."
    ))
} 