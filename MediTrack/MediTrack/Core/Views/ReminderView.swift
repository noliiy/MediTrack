import SwiftUI

struct ReminderView: View {
    let medication: Medication
    @Environment(\.dismiss) private var dismiss
    @State private var timeRemaining: TimeInterval = 120 // 2 minutes
    @State private var isTimerRunning = false
    @State private var showingCompletionAlert = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.theme.text)
                }
                
                Spacer()
                
                Text("Set Timer")
                    .font(.title3.bold())
                    .foregroundColor(.theme.text)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(.theme.text)
                }
            }
            .padding(.horizontal)
            
            // Timer Display
            ZStack {
                // Background Circle
                Circle()
                    .stroke(Color.theme.primary.opacity(0.2), lineWidth: 20)
                
                // Progress Circle
                Circle()
                    .trim(from: 0, to: timeRemaining / 120)
                    .stroke(Color.theme.primary, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: timeRemaining)
                
                VStack(spacing: 8) {
                    Text(timeString)
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.theme.text)
                    
                    Text("minutes remaining")
                        .font(.subheadline)
                        .foregroundColor(.theme.secondaryText)
                }
            }
            .frame(height: 300)
            .padding()
            
            // Medication Info
            VStack(spacing: 16) {
                Text(medication.name)
                    .font(.title2.bold())
                    .foregroundColor(.theme.text)
                
                Text(medication.intakeCondition.rawValue)
                    .font(.headline)
                    .foregroundColor(.theme.secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.theme.secondary.opacity(0.1))
                    .cornerRadius(12)
            }
            
            Spacer()
            
            // Control Buttons
            HStack(spacing: 20) {
                Button(action: {
                    isTimerRunning.toggle()
                }) {
                    Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(Color.theme.primary)
                        .clipShape(Circle())
                        .shadow(color: Color.theme.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                Button(action: {
                    timeRemaining = 120
                    isTimerRunning = false
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title)
                        .foregroundColor(.theme.primary)
                        .frame(width: 64, height: 64)
                        .background(Color.theme.primary.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.bottom, 40)
        }
        .padding(.top)
        .background(Color.theme.background.ignoresSafeArea())
        .onReceive(timer) { _ in
            guard isTimerRunning else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isTimerRunning = false
                showingCompletionAlert = true
            }
        }
        .alert("Time's Up!", isPresented: $showingCompletionAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Time to take your medication.")
        }
    }
    
    private var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ReminderView(medication: Medication(
        name: "Aspirin",
        dosage: "100mg",
        intakeCondition: .afterMeal,
        frequency: 1,
        times: [MedicationTime(hour: 9, minute: 0)]
    ))
} 