import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Bildirim izni verildi")
            } else if let error = error {
                print("Bildirim izni hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleMedicationReminder(for medication: Medication) {
        let center = UNUserNotificationCenter.current()
        
        // Önce bu ilaç için olan eski bildirimleri temizle
        center.removePendingNotificationRequests(withIdentifiers: [medication.id.uuidString])
        
        // Her bir ilaç alma zamanı için bildirim oluştur
        for time in medication.times {
            let content = UNMutableNotificationContent()
            content.title = "İlaç Hatırlatması"
            content.body = "\(medication.name) alma zamanı geldi - \(medication.intakeCondition.rawValue)"
            content.sound = .default
            
            // Bildirim zamanını ayarla
            var dateComponents = DateComponents()
            dateComponents.hour = time.hour
            dateComponents.minute = time.minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: "\(medication.id.uuidString)_\(time.id.uuidString)",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("Bildirim ekleme hatası: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func cancelAllReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
} 