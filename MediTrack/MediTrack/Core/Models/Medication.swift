import Foundation

struct Medication: Identifiable, Codable {
    let id: UUID
    let name: String        // İlaç adı
    let time: Date         // İlaç alım saati
    let instruction: String // Kullanım talimatı
    var isTaken: Bool      // İlacın alınıp alınmadığı
    
    init(id: UUID = UUID(), name: String, time: Date, instruction: String, isTaken: Bool = false) {
        self.id = id
        self.name = name
        self.time = time
        self.instruction = instruction
        self.isTaken = isTaken
    }
} 