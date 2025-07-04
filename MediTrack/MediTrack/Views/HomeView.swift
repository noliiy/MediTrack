import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var selectedDate = Date()
    @State private var selectedSpecialty = "All"
    
    let specialties = ["All", "Neurosurgery", "Dermatology", "Radiology", "Oncology"]
    
    let doctors = [
        Doctor(name: "Dr. Sara Dania", specialty: "Radiology Specialist", rating: 4.4, experience: "4 Years Experience", consultFee: 200, imageUrl: "doctor1"),
        Doctor(name: "Dr. Miles Slabs", specialty: "Radiology Specialist", rating: 4.2, experience: "2 Years Experience", consultFee: 100, imageUrl: "doctor2"),
        Doctor(name: "Dr. Ralph Edward", specialty: "General Surgeon", rating: 4.8, experience: "6 Years Experience", consultFee: 300, imageUrl: "doctor3")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Search Bar
                SearchBar(text: $searchText)
                
                // Calendar View
                CalendarView(selectedDate: $selectedDate)
                
                // Specialty Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(specialties, id: \.self) { specialty in
                            SpecialtyButton(title: specialty, isSelected: specialty == selectedSpecialty) {
                                selectedSpecialty = specialty
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Doctor List
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(doctors) { doctor in
                            DoctorCard(doctor: doctor)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Find Doctors")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search by doctor's name", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    let calendar = Calendar.current
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<14) { index in
                    if let date = calendar.date(byAdding: .day, value: index, to: Date()) {
                        DayButton(date: date, isSelected: calendar.isDate(date, inSameDayAs: selectedDate)) {
                            selectedDate = date
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct DayButton: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void
    let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1])
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .gray)
                
                Text("\(calendar.component(.day, from: date))")
                    .font(.title3.bold())
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 45, height: 70)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct SpecialtyButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct DoctorCard: View {
    let doctor: Doctor
    
    var body: some View {
        HStack(spacing: 15) {
            Image(doctor.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.name)
                    .font(.headline)
                
                Text(doctor.specialty)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", doctor.rating))
                        .font(.subheadline)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text(doctor.experience)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text("$\(Int(doctor.consultFee))")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Button(action: {}) {
                    Text("Book Now")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
} 