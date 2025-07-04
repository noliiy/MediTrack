import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var time = Date()
    @State private var instruction = "yemekle birlikte"
    
    let onSave: (Medication) -> Void
    let instructions = ["yemekle birlikte", "aç karnına", "uykudan önce"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("İlaç Adı", text: $name)
                    DatePicker("Saat", selection: $time, displayedComponents: .hourAndMinute)
                    Picker("Kullanım Talimatı", selection: $instruction) {
                        ForEach(instructions, id: \.self) { instruction in
                            Text(instruction)
                        }
                    }
                }
            }
            .navigationTitle("İlaç Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        let medication = Medication(
                            name: name,
                            time: time,
                            instruction: instruction
                        )
                        onSave(medication)
                        dismiss()
                    }
                }
            }
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
