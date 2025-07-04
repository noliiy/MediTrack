import Foundation

struct Medication: Identifiable {
    let id = UUID()
    let name: String
    let time: Date
    let instruction: String
    var isTaken: Bool
    let icon: String // SF Symbol name for the instruction icon
}

extension Medication {
    static let sampleMedications = [
        Medication(name: "Parol", time: Date.from(hour: 8, minute: 0), instruction: "on an empty stomach", isTaken: true, icon: "pills"),
        Medication(name: "Augumetin", time: Date.from(hour: 13, minute: 0), instruction: "with food", isTaken: false, icon: "fork.knife"),
        Medication(name: "Vitamin C", time: Date.from(hour: 20, minute: 0), instruction: "with food", isTaken: false, icon: "fork.knife")
    ]
}

extension Date {
    static func from(hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components) ?? Date()
    }
    
    func formatTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
} 