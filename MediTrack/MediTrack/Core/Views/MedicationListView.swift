import SwiftUI

struct MedicationListView: View {
    @StateObject private var viewModel = MedicationListViewModel()
    @State private var showingAddMedication = false
    
    var body: some View {
        NavigationView {
            List(viewModel.medications) { medication in
                MedicationRowView(medication: medication) {
                    viewModel.toggleMedicationStatus(medication)
                }
            }
            .navigationTitle("Today's Medications")
            .toolbar {
                Button(action: { showingAddMedication = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddMedication) {
                AddMedicationView { medication in
                    viewModel.addMedication(medication)
                }
            }
        }
    }
}

struct MedicationRowView: View {
    let medication: Medication
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(medication.name)
                    .font(.headline)
                Text(medication.instruction)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(medication.time, style: .time)
                    .font(.subheadline)
                
                Button(action: onToggle) {
                    Image(systemName: medication.isTaken ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(medication.isTaken ? .green : .gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
} 