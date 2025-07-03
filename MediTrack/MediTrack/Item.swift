//
//  Item.swift
//  MediTrack
//
//  Created by Emre Erdem on 3.07.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
