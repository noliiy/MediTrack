import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = MedicationViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    AdherenceChartView(adherenceData: viewModel.getAdherenceData())
                        .frame(height: 200)
                        .padding()
                    
                    TodaysMedicationsView(medications: viewModel.todaysMedications) { medication in
                        viewModel.markMedicationAsTaken(medication)
                    }
                }
                .padding()
            }
            .background(Color.theme.background)
            .navigationTitle("MediTrack")
            .navigationBarItems(trailing:
                Button(action: {
                    viewModel.showingAddMedication = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            )
            .sheet(isPresented: $viewModel.showingAddMedication) {
                AddMedicationView(viewModel: viewModel)
            }
        }
    }
}

struct TodaysMedicationsView: View {
    let medications: [Medication]
    let onMedicationTaken: (Medication) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Bugünkü İlaçlar")
                .font(.title2)
                .foregroundColor(Color.theme.text)
            
            if medications.isEmpty {
                Text("Bugün için planlanmış ilaç bulunmuyor")
                    .foregroundColor(Color.theme.secondary)
                    .padding()
            } else {
                ForEach(medications) { medication in
                    MedicationCardView(medication: medication, onTaken: {
                        onMedicationTaken(medication)
                    })
                }
            }
        }
    }
}

struct MedicationCardView: View {
    let medication: Medication
    let onTaken: () -> Void
    @State private var showingDetails = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(medication.name)
                        .font(.headline)
                        .foregroundColor(Color.theme.text)
                    
                    Text(medication.dosage)
                        .font(.subheadline)
                        .foregroundColor(Color.theme.secondary)
                    
                    Text(medication.intakeCondition.rawValue)
                        .font(.caption)
                        .foregroundColor(Color.theme.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.theme.primary.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: onTaken) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.theme.primary)
                        .font(.title2)
                }
            }
            
            if let notes = medication.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            ForEach(medication.times) { time in
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(Color.theme.secondary)
                    Text("\(time.hour):\(String(format: "%02d", time.minute))")
                        .font(.caption)
                        .foregroundColor(Color.theme.text)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    HomeView()
} 