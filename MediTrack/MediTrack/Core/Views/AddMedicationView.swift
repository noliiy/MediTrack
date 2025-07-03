import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MedicationViewModel
    
    @State private var name = ""
    @State private var dosage = ""
    @State private var intakeCondition: IntakeCondition = .afterMeal
    @State private var selectedHour = 9
    @State private var selectedMinute = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // İlaç Adı
                TextField("İlaç Adı", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Doz
                TextField("Doz (örn: 100mg)", text: $dosage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Alım Koşulu
                VStack(alignment: .leading, spacing: 8) {
                    Text("Alım Koşulu")
                        .font(.subheadline)
                        .foregroundColor(.theme.secondaryText)
                    
                    Picker("Alım Koşulu", selection: $intakeCondition) {
                        ForEach([IntakeCondition.beforeMeal,
                                IntakeCondition.afterMeal,
                                IntakeCondition.withMeal,
                                IntakeCondition.noMatter]) { condition in
                            Text(condition.rawValue).tag(condition)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
                
                // Zaman Seçimi
                VStack(alignment: .leading, spacing: 8) {
                    Text("Alım Zamanı")
                        .font(.subheadline)
                        .foregroundColor(.theme.secondaryText)
                    
                    HStack {
                        Picker("Saat", selection: $selectedHour) {
                            ForEach(0..<24) { hour in
                                Text("\(hour)").tag(hour)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100)
                        
                        Text(":")
                            .font(.title2)
                        
                        Picker("Dakika", selection: $selectedMinute) {
                            ForEach(0..<60) { minute in
                                Text(String(format: "%02d", minute)).tag(minute)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Yeni İlaç Ekle")
            .navigationBarItems(
                leading: Button("İptal") { dismiss() },
                trailing: Button("Kaydet") { saveMedication() }
                    .disabled(name.isEmpty || dosage.isEmpty)
            )
        }
    }
    
    private func saveMedication() {
        let medicationTime = MedicationTime(hour: selectedHour, minute: selectedMinute)
        
        let newMedication = Medication(
            name: name,
            dosage: dosage,
            intakeCondition: intakeCondition,
            frequency: 1,
            times: [medicationTime]
        )
        
        viewModel.addMedication(newMedication)
        dismiss()
    }
}

#Preview {
    AddMedicationView(viewModel: MedicationViewModel())
} 