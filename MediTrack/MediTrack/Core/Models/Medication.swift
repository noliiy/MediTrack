import Foundation

struct Medication: Identifiable, Codable {
    let id: UUID
    let name: String
    let time: Date
    let instruction: String
    var isTaken: Bool
    
    init(id: UUID = UUID(), name: String, time: Date, instruction: String, isTaken: Bool = false) {
        self.id = id
        self.name = name
        self.time = time
        self.instruction = instruction
        self.isTaken = isTaken
    }
} 