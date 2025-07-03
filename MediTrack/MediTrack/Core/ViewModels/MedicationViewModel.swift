import Foundation
import SwiftUI

class MedicationViewModel: ObservableObject {
    @Published var medications: [Medication] = []
    @Published var todaysMedications: [Medication] = []
    
    init() {
        loadMedications()
        updateTodaysMedications()
    }
    
    func loadMedications() {
        // TODO: Implement persistence
        // For now, using sample data
        let calendar = Calendar.current
        let now = Date()
        
        let sampleMed = Medication(
            name: "Aspirin",
            dosage: "100mg",
            frequency: 2,
            times: [
                calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now) ?? now,
                calendar.date(bySettingHour: 21, minute: 0, second: 0, of: now) ?? now
            ]
        )
        
        medications = [sampleMed]
    }
    
    func updateTodaysMedications() {
        let today = Calendar.current.startOfDay(for: Date())
        todaysMedications = medications.filter { medication in
            medication.times.contains { time in
                Calendar.current.isDate(time, inSameDayAs: today)
            }
        }
    }
    
    func markMedicationAsTaken(_ medication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index].takenDoses.append(Date())
        }
        updateTodaysMedications()
    }
    
    func getAdherenceData() -> [Double] {
        return medications.map { $0.adherenceRate * 100 }
    }
} 