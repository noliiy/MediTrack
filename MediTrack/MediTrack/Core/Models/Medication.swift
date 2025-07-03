import Foundation

struct Medication: Identifiable, Codable {
    let id: UUID
    let name: String
    let dosage: String
    let frequency: Int // Times per day
    let times: [Date] // Specific times to take the medication
    var takenDoses: [Date] // Dates when medication was taken
    
    init(id: UUID = UUID(), name: String, dosage: String, frequency: Int, times: [Date], takenDoses: [Date] = []) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.frequency = frequency
        self.times = times
        self.takenDoses = takenDoses
    }
    
    var adherenceRate: Double {
        guard !times.isEmpty else { return 0.0 }
        let totalExpectedDoses = frequency * Calendar.current.numberOfDaysBetween(times[0], and: Date())
        return Double(takenDoses.count) / Double(totalExpectedDoses)
    }
} 