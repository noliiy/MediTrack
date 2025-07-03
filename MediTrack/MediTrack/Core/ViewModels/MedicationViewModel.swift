import Foundation
import SwiftUI

// MARK: - ViewModel State
struct MedicationViewState {
    var medications: [Medication] = []
    var todaysMedications: [Medication] = []
    var showingAddMedication: Bool = false
    var selectedMedication: Medication?
    var error: Error?
}

// MARK: - ViewModel Actions
enum MedicationViewAction {
    case addMedication(Medication)
    case markMedicationTaken(Medication)
    case deleteMedication(Medication)
    case showAddMedication
    case hideAddMedication
    case selectMedication(Medication?)
}

// MARK: - ViewModel
final class MedicationViewModel: ObservableObject {
    @Published private(set) var state = MedicationViewState()
    private let notificationService = NotificationService.shared
    
    init() {
        loadMedications()
        updateTodaysMedications()
        notificationService.requestAuthorization()
    }
    
    // MARK: - Public Methods
    func dispatch(_ action: MedicationViewAction) {
        switch action {
        case .addMedication(let medication):
            addMedication(medication)
        case .markMedicationTaken(let medication):
            markMedicationTaken(medication)
        case .deleteMedication(let medication):
            deleteMedication(medication)
        case .showAddMedication:
            state.showingAddMedication = true
        case .hideAddMedication:
            state.showingAddMedication = false
        case .selectMedication(let medication):
            state.selectedMedication = medication
        }
    }
    
    // MARK: - Analytics Methods
    func getDailyProgress() -> Double {
        let totalDoses = state.todaysMedications.count
        guard totalDoses > 0 else { return 0 }
        
        let takenDoses = state.todaysMedications.reduce(0) { count, medication in
            let today = Calendar.current.startOfDay(for: Date())
            let takenToday = medication.takenDoses.filter {
                Calendar.current.isDate($0, inSameDayAs: today)
            }.count
            return count + takenToday
        }
        
        return Double(takenDoses) / Double(totalDoses)
    }
    
    func getOverallAdherence() -> Double {
        let adherenceRates = state.medications.map { $0.adherenceRate }
        guard !adherenceRates.isEmpty else { return 0 }
        return (adherenceRates.reduce(0, +) / Double(adherenceRates.count)) * 100
    }
    
    // MARK: - Private Methods
    private func loadMedications() {
        // TODO: Implement persistence
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
        
        state.medications = [sampleMed]
        state.medications.forEach { medication in
            notificationService.scheduleMedicationReminder(for: medication)
        }
    }
    
    private func updateTodaysMedications() {
        let today = Calendar.current.startOfDay(for: Date())
        state.todaysMedications = state.medications.filter { medication in
            medication.times.contains { time in
                let medicationDate = time.date
                return Calendar.current.isDate(medicationDate, inSameDayAs: today)
            }
        }
    }
    
    private func addMedication(_ medication: Medication) {
        state.medications.append(medication)
        notificationService.scheduleMedicationReminder(for: medication)
        updateTodaysMedications()
    }
    
    private func markMedicationTaken(_ medication: Medication) {
        if let index = state.medications.firstIndex(where: { $0.id == medication.id }) {
            state.medications[index].takenDoses.append(Date())
            updateTodaysMedications()
        }
    }
    
    private func deleteMedication(_ medication: Medication) {
        state.medications.removeAll { $0.id == medication.id }
        updateTodaysMedications()
    }
} 