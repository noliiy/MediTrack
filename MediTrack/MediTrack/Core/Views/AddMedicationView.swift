import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MedicationViewModel
    
    @State private var name = ""
    @State private var dosage = ""
    @State private var intakeCondition: IntakeCondition = .afterMeal
    @State private var frequency = 1
    @State private var notes = ""
    @State private var selectedTimes: [MedicationTime] = []
    @State private var showingTimePicker = false
    @State private var selectedHour = 9
    @State private var selectedMinute = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("İlaç Bilgileri")) {
                    TextField("İlaç Adı", text: $name)
                    TextField("Doz (örn: 100mg)", text: $dosage)
                }
                
                Section(header: Text("Alım Koşulları")) {
                    Picker("Alım Durumu", selection: $intakeCondition) {
                        ForEach([IntakeCondition.beforeMeal,
                                IntakeCondition.afterMeal,
                                IntakeCondition.withMeal,
                                IntakeCondition.noMatter]) { condition in
                            Text(condition.rawValue).tag(condition)
                        }
                    }
                }
                
                Section(header: Text("Zamanlama")) {
                    Stepper("Günlük Alım Sayısı: \(frequency)", value: $frequency, in: 1...10)
                    
                    ForEach(selectedTimes) { time in
                        HStack {
                            Text("\(time.hour):\(String(format: "%02d", time.minute))")
                            Spacer()
                            Button(action: {
                                selectedTimes.removeAll(where: { $0.id == time.id })
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Button("Zaman Ekle") {
                        showingTimePicker = true
                    }
                }
                
                Section(header: Text("Notlar")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Yeni İlaç Ekle")
            .navigationBarItems(
                leading: Button("İptal") { dismiss() },
                trailing: Button("Kaydet") { saveMedication() }
                    .disabled(name.isEmpty || dosage.isEmpty || selectedTimes.isEmpty)
            )
            .sheet(isPresented: $showingTimePicker) {
                NavigationView {
                    Form {
                        Section {
                            Picker("Saat", selection: $selectedHour) {
                                ForEach(0..<24) { hour in
                                    Text("\(hour)").tag(hour)
                                }
                            }
                            Picker("Dakika", selection: $selectedMinute) {
                                ForEach(0..<60) { minute in
                                    Text(String(format: "%02d", minute)).tag(minute)
                                }
                            }
                        }
                    }
                    .navigationTitle("Zaman Seç")
                    .navigationBarItems(
                        trailing: Button("Ekle") {
                            let newTime = MedicationTime(hour: selectedHour, minute: selectedMinute)
                            selectedTimes.append(newTime)
                            showingTimePicker = false
                        }
                    )
                }
            }
        }
    }
    
    private func saveMedication() {
        let newMedication = Medication(
            name: name,
            dosage: dosage,
            intakeCondition: intakeCondition,
            frequency: frequency,
            times: selectedTimes,
            notes: notes.isEmpty ? nil : notes
        )
        
        viewModel.addMedication(newMedication)
        dismiss()
    }
}

#Preview {
    AddMedicationView(viewModel: MedicationViewModel())
} 