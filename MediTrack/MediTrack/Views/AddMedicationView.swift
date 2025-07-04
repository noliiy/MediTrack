import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var medicationName = ""
    @State private var selectedTime = Date()
    @State private var selectedInstruction = "with food"
    
    let instructions = ["with food", "on an empty stomach", "before sleep"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Details")) {
                    TextField("Medication Name", text: $medicationName)
                    
                    DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    
                    Picker("Instructions", selection: $selectedInstruction) {
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
                        // Save medication logic here
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddMedicationView()
} 