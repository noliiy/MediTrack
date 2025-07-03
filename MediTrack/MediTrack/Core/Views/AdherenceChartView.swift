import SwiftUI

struct AdherenceChartView: View {
    let adherenceData: [Double]
    
    private var totalAdherence: Double {
        guard !adherenceData.isEmpty else { return 0 }
        return adherenceData.reduce(0, +) / Double(adherenceData.count)
    }
    
    var body: some View {
        VStack {
            Text("Medication Adherence")
                .font(.title2)
                .foregroundColor(Color.theme.text)
            
            ZStack {
                Circle()
                    .stroke(Color.theme.secondary.opacity(0.2), lineWidth: 20)
                
                Circle()
                    .trim(from: 0, to: totalAdherence / 100)
                    .stroke(Color.theme.primary, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: totalAdherence)
                
                VStack {
                    Text("\(Int(totalAdherence))%")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color.theme.text)
                    
                    Text("Adherence")
                        .font(.subheadline)
                        .foregroundColor(Color.theme.secondary)
                }
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 2)
    }
}

#Preview {
    AdherenceChartView(adherenceData: [75.0, 80.0, 90.0])
        .frame(height: 300)
        .padding()
} 