import SwiftUI

struct DashboardView: View {
    @State private var medications = Medication.sampleMedications
    @State private var showingAddMedication = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header Image
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemBlue).opacity(0.2))
                        .frame(height: 200)
                    
                    HStack(spacing: 30) {
                        Image(systemName: "pills.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                        
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                
                // Medications List
                VStack(alignment: .leading, spacing: 16) {
                    Text("Today's Medications")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ForEach(medications) { medication in
                        MedicationRow(medication: medication)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("MediTrack")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddMedication = true }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddMedication) {
                AddMedicationView()
            }
        }
    }
}

struct MedicationRow: View {
    let medication: Medication
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(medication.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                HStack {
                    Image(systemName: medication.icon)
                        .foregroundColor(.blue)
                    Text(medication.instruction)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text(medication.time.formatTime())
                    .font(.headline)
                
                Image(systemName: medication.isTaken ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(medication.isTaken ? .green : .gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    DashboardView()
} 