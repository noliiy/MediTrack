import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = MedicationViewModel()
    @State private var selectedTab = 0
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                TabView(selection: $selectedTab) {
                    todayView
                        .tag(0)
                    
                    statisticsView
                        .tag(1)
                    
                    settingsView
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                customTabBar
            }
        }
        .sheet(isPresented: $viewModel.showingAddMedication) {
            AddMedicationView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Merhaba")
                    .font(.title3)
                    .foregroundColor(.theme.secondaryText)
                
                Text("İlaç Zamanı")
                    .font(.title.bold())
                    .foregroundColor(.theme.text)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.showingAddMedication = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.theme.primary)
                    .padding(8)
                    .background(Color.theme.cardBackground)
                    .clipShape(Circle())
            }
        }
        .padding()
    }
    
    private var todayView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Günlük İlerleme Kartı
                DailyProgressCard(progress: viewModel.getDailyProgress())
                    .transition(.scale)
                
                // Bugünkü İlaçlar
                VStack(alignment: .leading, spacing: 16) {
                    Text("Bugünkü İlaçlar")
                        .font(.title2.bold())
                        .foregroundColor(.theme.text)
                        .padding(.horizontal)
                    
                    if viewModel.todaysMedications.isEmpty {
                        EmptyMedicationView()
                    } else {
                        ForEach(viewModel.todaysMedications) { medication in
                            MedicationCardView(medication: medication) {
                                withAnimation {
                                    viewModel.markMedicationAsTaken(medication)
                                }
                            }
                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                                  removal: .scale.combined(with: .opacity)))
                        }
                    }
                }
            }
            .padding(.top)
        }
    }
    
    private var statisticsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // İlaç Uyum Grafiği
                AdherenceChartView(adherenceData: viewModel.getAdherenceData())
                    .frame(height: 200)
                    .padding()
                    .background(Color.theme.cardBackground)
                    .cornerRadius(20)
                
                // Aylık İstatistikler
                MonthlyStatsView(viewModel: viewModel)
            }
            .padding()
        }
    }
    
    private var settingsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Ayarlar içeriği gelecek
                Text("Ayarlar")
                    .font(.title)
            }
            .padding()
        }
    }
    
    private var customTabBar: some View {
        HStack {
            ForEach(0..<3) { index in
                Spacer()
                TabBarButton(
                    imageName: tabBarImageName(for: index),
                    title: tabBarTitle(for: index),
                    isSelected: selectedTab == index,
                    animation: animation
                ) {
                    withAnimation {
                        selectedTab = index
                    }
                }
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(Color.theme.cardBackground)
    }
    
    private func tabBarImageName(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "chart.bar.fill"
        case 2: return "gearshape.fill"
        default: return ""
        }
    }
    
    private func tabBarTitle(for index: Int) -> String {
        switch index {
        case 0: return "Ana Sayfa"
        case 1: return "İstatistik"
        case 2: return "Ayarlar"
        default: return ""
        }
    }
}

struct TabBarButton: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    let animation: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: imageName)
                    .font(.system(size: 24))
                
                Text(title)
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? .theme.primary : .theme.secondaryText)
            .overlay(
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.theme.primary.opacity(0.2))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
            )
        }
    }
}

struct DailyProgressCard: View {
    let progress: Double
    @State private var showProgress = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Günlük İlerleme")
                .font(.title3.bold())
                .foregroundColor(.white)
            
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 15)
                
                Circle()
                    .trim(from: 0, to: showProgress ? progress : 0)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1, dampingFraction: 0.8), value: showProgress)
                
                VStack {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Tamamlandı")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(width: 200, height: 200)
        }
        .padding()
        .background(Color.theme.primaryGradient)
        .cornerRadius(25)
        .shadow(radius: 10)
        .padding(.horizontal)
        .onAppear {
            showProgress = true
        }
    }
}

struct EmptyMedicationView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "pills.fill")
                .font(.system(size: 60))
                .foregroundColor(.theme.secondary)
            
            Text("Bugün için planlanmış ilaç bulunmuyor")
                .font(.headline)
                .foregroundColor(.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(Color.theme.cardBackground)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct MonthlyStatsView: View {
    @ObservedObject var viewModel: MedicationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Aylık İstatistikler")
                .font(.title3.bold())
                .foregroundColor(.theme.text)
            
            HStack(spacing: 20) {
                StatCard(
                    title: "Toplam İlaç",
                    value: "\(viewModel.medications.count)",
                    icon: "pills.fill"
                )
                
                StatCard(
                    title: "Uyum Oranı",
                    value: "\(Int(viewModel.getOverallAdherence()))%",
                    icon: "chart.line.uptrend.xyaxis"
                )
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.theme.primary)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title2.bold())
                    .foregroundColor(.theme.text)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.theme.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.theme.cardBackground)
        .cornerRadius(15)
    }
}

#Preview {
    HomeView()
} 