import Foundation

struct Doctor: Identifiable {
    let id = UUID()
    let name: String
    let specialty: String
    let rating: Double
    let experience: String
    let consultFee: Double
    let imageUrl: String
} 