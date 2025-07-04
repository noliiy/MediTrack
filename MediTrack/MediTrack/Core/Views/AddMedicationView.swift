import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var time = Date()
    @State private var instruction = "with food"
    
    let onSave: (Medication) -> Void
    let instructions = ["with food", "on an empty stomach", "before sleep"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Medication Name", text: $name)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    Picker("Instructions", selection: $instruction) {
                        ForEach(instructions, id: \.self) { instruction in
                            Text(instruction)
                        }
                    }
                }
            }
            .navigationTitle("Add Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
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
