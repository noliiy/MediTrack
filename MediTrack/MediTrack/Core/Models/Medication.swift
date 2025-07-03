import Foundation

enum IntakeCondition: String, Codable, Identifiable {
    case beforeMeal = "Aç Karnına"
    case afterMeal = "Tok Karnına"
    case withMeal = "Yemek İle Birlikte"
    case noMatter = "Farketmez"
    
    var id: String { rawValue }
}

struct MedicationTime: Codable, Identifiable {
    let id: UUID
    let hour: Int
    let minute: Int
    var date: Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
    }
    
    init(id: UUID = UUID(), hour: Int, minute: Int) {
        self.id = id
        self.hour = hour
        self.minute = minute
    }
}

struct Medication: Identifiable, Codable {
    let id: UUID
    let name: String
    let dosage: String
    let intakeCondition: IntakeCondition
    let frequency: Int // Times per day
    let times: [MedicationTime] // Specific times to take the medication
    var takenDoses: [Date] // Dates when medication was taken
    let notes: String?
    let startDate: Date
    let endDate: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        dosage: String,
        intakeCondition: IntakeCondition,
        frequency: Int,
        times: [MedicationTime],
        takenDoses: [Date] = [],
        notes: String? = nil,
        startDate: Date = Date(),
        endDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.intakeCondition = intakeCondition
        self.frequency = frequency
        self.times = times
        self.takenDoses = takenDoses
        self.notes = notes
        self.startDate = startDate
        self.endDate = endDate
    }
    
    var adherenceRate: Double {
        guard !times.isEmpty else { return 0.0 }
        let totalExpectedDoses = frequency * Calendar.current.numberOfDaysBetween(startDate, and: Date())
        return Double(takenDoses.count) / Double(totalExpectedDoses)
    }
    
    func isTimeToTake(at currentTime: Date = Date()) -> Bool {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: currentTime)
        let currentMinute = calendar.component(.minute, from: currentTime)
        
        return times.contains { medicationTime in
            medicationTime.hour == currentHour &&
            abs(medicationTime.minute - currentMinute) < 30 // 30 dakika tolerans
        }
    }
    
    var nextDoseTime: Date? {
        let now = Date()
        return times
            .map { $0.date }
            .filter { $0 > now }
            .min()
    }
} 