import Foundation
import SwiftUI

class MedicationViewModel: ObservableObject {
    @Published var medications: [Medication] = []
    @Published var todaysMedications: [Medication] = []
    @Published var showingAddMedication = false
    
    private let notificationService = NotificationService.shared
    
    init() {
        loadMedications()
        updateTodaysMedications()
        notificationService.requestAuthorization()
    }
    
    func loadMedications() {
        // TODO: Implement persistence
        // For now, using sample data
        let morningTime = MedicationTime(hour: 9, minute: 0)
        let eveningTime = MedicationTime(hour: 21, minute: 0)
        
        let sampleMed = Medication(
            name: "Aspirin",
            dosage: "100mg",
            intakeCondition: .afterMeal,
            frequency: 2,
            times: [morningTime, eveningTime],
            notes: "Yemekten 30 dakika sonra alınmalı"
        )
        
        medications = [sampleMed]
        
        // Her ilaç için bildirimleri ayarla
        medications.forEach { medication in
            notificationService.scheduleMedicationReminder(for: medication)
        }
    }
    
    func updateTodaysMedications() {
        let today = Calendar.current.startOfDay(for: Date())
        todaysMedications = medications.filter { medication in
            medication.times.contains { time in
                let medicationDate = time.date
                return Calendar.current.isDate(medicationDate, inSameDayAs: today)
            }
        }
    }
    
    func addMedication(_ medication: Medication) {
        medications.append(medication)
        notificationService.scheduleMedicationReminder(for: medication)
        updateTodaysMedications()
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
    
    func getMedicationStatus(_ medication: Medication) -> String {
        if medication.isTimeToTake() {
            return "Şimdi Alınmalı - \(medication.intakeCondition.rawValue)"
        } else if let nextTime = medication.nextDoseTime {
            return "Sonraki Doz: \(nextTime.formatted(date: .omitted, time: .shortened)) - \(medication.intakeCondition.rawValue)"
        } else {
            return "Bugün için doz kalmadı"
        }
    }
} 