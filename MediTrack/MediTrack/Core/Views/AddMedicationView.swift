import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MedicationViewModel
    
    @State private var name = ""
    @State private var dosage = ""
    @State private var intakeCondition: IntakeCondition = .afterMeal
    @State private var selectedHour = 9
    @State private var selectedMinute = 0
    @State private var notes = ""
    @State private var showAlert = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // İlaç Adı
                        VStack(alignment: .leading, spacing: 8) {
                            Label("İlaç Adı", systemImage: "pills")
                                .font(.headline)
                                .foregroundColor(.theme.text)
                            
                            TextField("Örn: Aspirin", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Doz
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Doz", systemImage: "scalemass")
                                .font(.headline)
                                .foregroundColor(.theme.text)
                            
                            TextField("Örn: 100mg", text: $dosage)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Alım Koşulu
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Alım Koşulu", systemImage: "clock")
                                .font(.headline)
                                .foregroundColor(.theme.text)
                            
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
                        
                        // Zaman Seçimi
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Alım Zamanı", systemImage: "alarm")
                                .font(.headline)
                                .foregroundColor(.theme.text)
                            
                            HStack {
                                Picker("Saat", selection: $selectedHour) {
                                    ForEach(0..<24) { hour in
                                        Text("\(hour)").tag(hour)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 100)
                                
                                Text(":")
                                    .font(.title2.bold())
                                    .foregroundColor(.theme.text)
                                
                                Picker("Dakika", selection: $selectedMinute) {
                                    ForEach(0..<60) { minute in
                                        Text(String(format: "%02d", minute)).tag(minute)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 100)
                            }
                            .padding()
                            .background(Color.theme.cardBackground)
                            .cornerRadius(16)
                        }
                        
                        // Notlar
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Notlar", systemImage: "text.quote")
                                .font(.headline)
                                .foregroundColor(.theme.text)
                            
                            TextEditor(text: $notes)
                                .frame(height: 100)
                                .padding(12)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.theme.secondaryBackground, lineWidth: 1)
                                )
                        }
                        
                        // Kaydet Butonu
                        Button(action: saveMedication) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .padding(.trailing, 8)
                                }
                                
                                Text("Kaydet")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                name.isEmpty || dosage.isEmpty ?
                                Color.theme.primary.opacity(0.5) :
                                Color.theme.primary
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                        }
                        .disabled(name.isEmpty || dosage.isEmpty || isLoading)
                        .padding(.top, 16)
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Yeni İlaç Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                    .foregroundColor(.theme.secondary)
                }
            }
            .alert("İlaç Kaydedildi", isPresented: $showAlert) {
                Button("Tamam", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("\(name) başarıyla kaydedildi.")
            }
        }
    }
    
    private func saveMedication() {
        isLoading = true
        
        // Simüle edilmiş gecikme (gerçek uygulamada kaldırılabilir)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let medicationTime = MedicationTime(hour: selectedHour, minute: selectedMinute)
            
            let newMedication = Medication(
                name: name,
                dosage: dosage,
                intakeCondition: intakeCondition,
                frequency: 1,
                times: [medicationTime],
                notes: notes.isEmpty ? nil : notes
            )
            
            viewModel.dispatch(.addMedication(newMedication))
            isLoading = false
            showAlert = true
        }
    }
}

// MARK: - Custom Styles
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.theme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.theme.secondaryBackground, lineWidth: 1)
            )
    }
}

#Preview {
    AddMedicationView(viewModel: MedicationViewModel())
} 