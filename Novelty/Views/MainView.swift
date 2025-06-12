//
//  ContentView.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var manager: NoveltyManager
    @EnvironmentObject var timeManager: TimeManager
    @AppStorage("onboarding") var onboarding: Bool = false
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity
    @AppStorage("StartDate") var StartDate: TimeInterval = Date().timeIntervalSince1970
    @State private var id = "1"
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 16) {
                ScrollView{
                    VStack(alignment: .leading, spacing: 16) {
                        Text("inner archive")
                            .font(.extrabold(size: 40))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.purple)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.top, 30)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                    .padding(.trailing, 40)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 16) {
                        ForEach(getDaysBetween().reversed(), id: \.self) { day in
                                if let novelty = manager.history.first(where: { $0.createdAt?.formatted(date: .numeric, time: .omitted) == day.formatted(date: .numeric, time: .omitted) }) {
                                    NavigationLink(destination: NoveltyDetailView(novelty: novelty)) {
                                        CircleView(color1: Color(hex: novelty.colors![0]),
                                                   color2: Color(hex: novelty.colors![1]),
                                                   color3: Color(hex: novelty.colors![2]),
                                                   color4: Color(hex: novelty.colors![3]))
                                    }
                                } else if Calendar.current.isDateInToday(day) {
                                    Button(action: {
                                        donoveltynow()
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.purple.opacity(0.8))
                                                .frame(width: 48, height: 48)
                                            Image(systemName: "plus")
                                                .foregroundColor(.white)
                                                .font(.system(size: 24, weight: .bold))
                                        }
                                    }
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0))
                                        .frame(width: 48, height: 48)
                                }
                            }
                        }
                    .padding(5)
                    Spacer()
                }
            }
        }
    }
    private func donoveltynow() {
        NextNoveltyTime = Date().timeIntervalSince1970
    }
    func getDaysBetween() -> [Date] {
        var dates: [Date] = []
        var endDate = Date()
        var startDate = Date(timeIntervalSince1970: StartDate)
        var currentDate = startDate
        let calendar = Calendar.current

        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
}

struct CircleView: View {
    var color1: Color
    var color2: Color
    var color3: Color
    var color4: Color
    
    var Gradient: [Gradient.Stop] {
        [
            .init(color: color1, location: 0.1),
            .init(color: color2, location: 0.2),
            .init(color: color3, location: 0.3),
            .init(color: color4, location: 0.4)
        ]
    }
    var body: some View {
        Circle()
            .fill(RadialGradient(stops: Gradient, center: .center, startRadius: 0, endRadius: 48))
            .frame(width: 48, height: 48)
    }
}

#Preview{
    CircleView(color1: .purple, color2: .pink, color3: .yellow, color4: .orange)
}
