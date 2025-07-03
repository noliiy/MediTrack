import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = MedicationViewModel()
    @State private var selectedDate = Date()
    @State private var showingAddMedication = false
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hello,")
                            .font(.title3)
                            .foregroundColor(.theme.secondaryText)
                        Text("Sophia")
                            .font(.title.bold())
                            .foregroundColor(.theme.text)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.title2)
                            .foregroundColor(.theme.primary)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .theme.primary.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.horizontal)
                
                // Calendar
                VStack(spacing: 16) {
                    HStack {
                        Text(dateFormatter.string(from: selectedDate))
                            .font(.title3.bold())
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Button(action: { moveMonth(by: -1) }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.theme.text)
                            }
                            
                            Button(action: { moveMonth(by: 1) }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.theme.text)
                            }
                        }
                    }
                    
                    // Weekday headers
                    HStack {
                        ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                            Text(day)
                                .font(.subheadline)
                                .foregroundColor(.theme.secondaryText)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Calendar grid
                    let days = generateDaysInMonth()
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                        ForEach(days, id: \.self) { date in
                            if let date = date {
                                DayCell(date: date, isSelected: calendar.isDate(date, inSameDayAs: selectedDate))
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedDate = date
                                        }
                                    }
                            } else {
                                Color.clear
                                    .aspectRatio(1, contentMode: .fill)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.theme.cardBackground)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
                .padding(.horizontal)
                
                // Statistics Cards
                HStack(spacing: 16) {
                    StatCard(
                        title: "Time",
                        value: "1:30",
                        subtitle: "Hours",
                        color: .theme.primary,
                        icon: "clock.fill"
                    )
                    
                    StatCard(
                        title: "Exercises",
                        value: "12/8",
                        subtitle: "Tasks",
                        color: .theme.accent,
                        icon: "pills.fill"
                    )
                }
                .padding(.horizontal)
                
                // Weekly Progress
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Weekly points")
                            .font(.title3.bold())
                        
                        Spacer()
                        
                        Text("1544")
                            .font(.title2.bold())
                            .foregroundColor(.theme.primary)
                        
                        Text("+6%")
                            .font(.subheadline)
                            .foregroundColor(.theme.success)
                    }
                    
                    // Progress Ring
                    ZStack {
                        Circle()
                            .stroke(Color.theme.primary.opacity(0.2), lineWidth: 8)
                        
                        Circle()
                            .trim(from: 0, to: 0.64)
                            .stroke(Color.theme.primary, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        
                        Text("64%")
                            .font(.title2.bold())
                            .foregroundColor(.theme.text)
                    }
                    .frame(height: 150)
                    .padding(.vertical)
                }
                .padding()
                .background(Color.theme.cardBackground)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.theme.background.ignoresSafeArea())
        .sheet(isPresented: $showingAddMedication) {
            AddMedicationView(viewModel: viewModel)
        }
    }
    
    private func moveMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func generateDaysInMonth() -> [Date?] {
        let interval = calendar.dateInterval(of: .month, for: selectedDate)!
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        let daysInMonth = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: interval.start) {
                days.append(date)
            }
        }
        
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    private let calendar = Calendar.current
    
    var body: some View {
        Text("\(calendar.component(.day, from: date))")
            .font(.system(.subheadline, design: .rounded))
            .foregroundColor(isSelected ? .white : .theme.text)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .background(
                Circle()
                    .fill(isSelected ? Color.theme.primary : Color.clear)
            )
            .overlay(
                Circle()
                    .stroke(Color.theme.primary.opacity(0.3), lineWidth: isSelected ? 0 : 1)
            )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.theme.text)
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .padding(8)
                    .background(color.opacity(0.2))
                    .clipShape(Circle())
            }
            
            Text(value)
                .font(.title.bold())
                .foregroundColor(.theme.text)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.theme.secondaryText)
        }
        .padding()
        .background(Color.theme.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
    }
}

#Preview {
    DashboardView()
} 