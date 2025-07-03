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
        }
    }
}

struct TodaysMedicationsView: View {
    let medications: [Medication]
    let onMedicationTaken: (Medication) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Medications")
                .font(.title2)
                .foregroundColor(Color.theme.text)
            
            ForEach(medications) { medication in
                MedicationCardView(medication: medication, onTaken: {
                    onMedicationTaken(medication)
                })
            }
        }
    }
}

struct MedicationCardView: View {
    let medication: Medication
    let onTaken: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(medication.name)
                    .font(.headline)
                    .foregroundColor(Color.theme.text)
                
                Text(medication.dosage)
                    .font(.subheadline)
                    .foregroundColor(Color.theme.secondary)
                
                Text("Next dose: \(medication.times.first?.formatted(date: .omitted, time: .shortened) ?? "")")
                    .font(.caption)
                    .foregroundColor(Color.theme.text)
            }
            
            Spacer()
            
            Button(action: onTaken) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.theme.primary)
                    .font(.title2)
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