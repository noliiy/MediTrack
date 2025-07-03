import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = MedicationViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    TabView(selection: $selectedTab) {
                        // Ana Sayfa
                        VStack {
                            // Günlük İlerleme Kartı
                            ProgressCard(progress: viewModel.getDailyProgress())
                                .padding(.horizontal)
                                .padding(.top, 20)
                            
                            // İlaç Durumu
                            if let condition = viewModel.state.todaysMedications.first?.intakeCondition {
                                MedicationStatusView(condition: condition)
                                    .padding(.top, 20)
                            }
                            
                            Spacer()
                        }
                        .tag(0)
                        
                        // Tamamlanan İlaçlar
                        VStack {
                            Text("Tamamlanan İlaçlar")
                                .font(.title2.bold())
                                .foregroundColor(.theme.text)
                                .padding()
                            
                            Spacer()
                        }
                        .tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    // Alt Menü
                    BottomMenuView(selectedTab: $selectedTab)
                }
            }
            .navigationBarItems(
                trailing: Button(action: {
                    viewModel.dispatch(.showAddMedication)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.theme.primary)
                }
            )
        }
        .sheet(isPresented: .init(
            get: { viewModel.state.showingAddMedication },
            set: { isPresented in
                if !isPresented {
                    viewModel.dispatch(.hideAddMedication)
                }
            }
        )) {
            AddMedicationView(viewModel: viewModel)
        }
    }
}

// MARK: - Supporting Views
private struct ProgressCard: View {
    let progress: Double
    @State private var showProgress = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Günlük İlerleme")
                .font(.title3)
                .foregroundColor(.white)
            
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: showProgress ? progress : 0)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Tamamlandı")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(40)
        }
        .padding()
        .background(Color.theme.primary)
        .cornerRadius(20)
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
        VStack(spacing: 8) {
            Image(systemName: "clock")
                .font(.system(size: 24))
                .foregroundColor(.theme.primary)
            
            Text(condition.rawValue)
                .font(.system(size: 16))
                .foregroundColor(.theme.primary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.theme.cardBackground)
        .cornerRadius(15)
    }
}

// BottomMenuView is defined in a separate file

#Preview {
    HomeView()
} 