import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = MedicationViewModel()
    @State private var selectedTab = 0
    @State private var showingAddMedication = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    TabView(selection: $selectedTab) {
                        // Ana Sayfa
                        ScrollView {
                            VStack(spacing: 24) {
                                // Günlük İlerleme Kartı
                                ProgressCard(progress: viewModel.getDailyProgress())
                                    .padding(.horizontal)
                                
                                // İlaç Durumu
                                if let condition = viewModel.state.todaysMedications.first?.intakeCondition {
                                    MedicationStatusView(condition: condition)
                                }
                                
                                // Bugünkü İlaçlar
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Bugünkü İlaçlar")
                                        .font(.title2.bold())
                                        .foregroundColor(.theme.text)
                                        .padding(.horizontal)
                                    
                                    ForEach(viewModel.state.todaysMedications) { medication in
                                        MedicationCardView(
                                            medication: medication,
                                            onTaken: {
                                                viewModel.dispatch(.markMedicationTaken(medication))
                                            }
                                        )
                                    }
                                }
                            }
                            .padding(.top, 24)
                        }
                        .tag(0)
                        
                        // Tamamlanan İlaçlar
                        ScrollView {
                            VStack(spacing: 24) {
                                // Genel Uyum Grafiği
                                AdherenceChartView(adherenceData: [
                                    viewModel.getOverallAdherence()
                                ])
                                .frame(height: 300)
                                .padding()
                                
                                // Tamamlanan İlaçlar Listesi
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Tamamlanan İlaçlar")
                                        .font(.title2.bold())
                                        .foregroundColor(.theme.text)
                                        .padding(.horizontal)
                                    
                                    ForEach(viewModel.state.medications.filter { !$0.takenDoses.isEmpty }) { medication in
                                        MedicationCardView(
                                            medication: medication,
                                            onTaken: {}
                                        )
                                    }
                                }
                            }
                            .padding(.top, 24)
                        }
                        .tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    // Toolbar
                    CustomToolbar(showingAddMedication: $showingAddMedication)
                        .padding(.bottom, 8)
                    
                    // Alt Menü
                    BottomMenuView(selectedTab: $selectedTab)
                }
            }
            .navigationBarTitle("MediTrack", displayMode: .inline)
        }
        .sheet(isPresented: $showingAddMedication) {
            AddMedicationView(viewModel: viewModel)
        }
    }
}

// MARK: - Custom Toolbar
struct CustomToolbar: View {
    @Binding var showingAddMedication: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            Spacer()
            
            Button(action: { showingAddMedication = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    Text("İlaç Ekle")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.theme.primary)
                .cornerRadius(25)
                .shadow(color: Color.theme.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

// MARK: - Supporting Views
private struct ProgressCard: View {
    let progress: Double
    @State private var showProgress = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Günlük İlerleme")
                .font(.title3.bold())
                .foregroundColor(.white)
            
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: showProgress ? progress : 0)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Tamamlandı")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(40)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.theme.primaryGradient)
        )
        .shadow(color: Color.theme.primary.opacity(0.3), radius: 20, x: 0, y: 10)
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                showProgress = true
            }
        }
    }
}

private struct MedicationStatusView: View {
    let condition: IntakeCondition
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.theme.primary)
            
            Text(condition.rawValue)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.theme.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.theme.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.theme.shadowColor, radius: 15, x: 0, y: 5)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
} 