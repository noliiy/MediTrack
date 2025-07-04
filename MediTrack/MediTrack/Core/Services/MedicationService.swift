import Foundation

protocol MedicationServiceProtocol {
    func getTodaysMedications() -> [Medication]
    func addMedication(_ medication: Medication)
    func updateMedication(_ medication: Medication)
}

class MedicationService: MedicationServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let medicationsKey = "savedMedications"
    
    func getTodaysMedications() -> [Medication] {
        guard let data = userDefaults.data(forKey: medicationsKey),
              let medications = try? JSONDecoder().decode([Medication].self, from: data) else {
            return []
        }
        return medications
    }
    
    func addMedication(_ medication: Medication) {
        var medications = getTodaysMedications()
        medications.append(medication)
        saveMedications(medications)
    }
    
    func updateMedication(_ medication: Medication) {
        var medications = getTodaysMedications()
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index] = medication
            saveMedications(medications)
        }
    }
    
    private func saveMedications(_ medications: [Medication]) {
        if let encoded = try? JSONEncoder().encode(medications) {
            userDefaults.set(encoded, forKey: medicationsKey)
        }
    }
} 