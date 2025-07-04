import Foundation

class MedicationListViewModel: ObservableObject {
    @Published var medications: [Medication] = []
    @Published var errorMessage: String?
    
    private let medicationService: MedicationServiceProtocol
    
    init(medicationService: MedicationServiceProtocol = MedicationService()) {
        self.medicationService = medicationService
        loadMedications()
    }
    
    func loadMedications() {
        medications = medicationService.getTodaysMedications()
    }
    
    func toggleMedicationStatus(_ medication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            var updatedMedication = medication
            updatedMedication.isTaken.toggle()
            medications[index] = updatedMedication
            medicationService.updateMedication(updatedMedication)
        }
    }
    
    func addMedication(_ medication: Medication) {
        medicationService.addMedication(medication)
        loadMedications()
    }
} 