//
//  NoveltyDetailView.swift
//  Novelty
//
//  Created by Fabio on 12/06/25.
//
import SwiftUI

struct NoveltyDetailView : View {
    let novelty: Novelty?
    @EnvironmentObject var manager: NoveltyManager

    var body: some View {
        ZStack{
            BackgroundView(color1: Color(hex: novelty?.colors?[0] ?? "000000"),
                           color2: Color(hex: novelty?.colors?[1] ?? "000000"),
                           color3: Color(hex: novelty?.colors?[2] ?? "000000"),
                           color4: Color(hex: novelty?.colors?[3] ?? "000000"))
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Text(formatDate(novelty?.createdAt ?? Date()))
                    .font(.italic(size: 25))
                    .frame(alignment: .leading)
                    .foregroundStyle(.white)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 20)
                Text("\(novelty?.title ?? "No Novelty")")
                    .font(.extrabold(size: 40))
                    .frame(alignment: .leading)
                    .foregroundStyle(.white)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 10)
                Text("\(novelty?.description ?? "No Novelty")")
                    .font(.italic(size: 25))
                    .frame(alignment: .leading)
                    .foregroundStyle(.white)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.leading, 20)
                    .padding(.bottom, 30)
                Text("\(novelty?.feedback?.feedbackquestion ?? "No Novelty")")
                    .font(.extrabold(size: 40))
                    .frame(alignment: .leading)
                    .foregroundStyle(.white)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 10)
                    .padding(.top, 30)
                Text("\(novelty?.feedback?.feedbackanswer ?? "No Novelty")")
                    .font(.italic(size: 25))
                    .frame(alignment: .leading)
                    .foregroundStyle(.white)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.leading, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            .padding(.trailing, 40)
            .padding(.top, 20)
        }
    }
}

#Preview {
    NoveltyDetailView(novelty: Novelty(
        id: "1",
        title: "Sample Novelty",
        description: "This is a sample novelty description.",
        category: "s",
        duration: 300,
        status: .accepted,
        colors: ["FF5733", "33FF57", "3357FF", "F0F0F0"],
        feedback: Feedback(id: "1", feedbackquestion: "How was your experience?", feedbackanswer: "It was great!")
    ))
    .environmentObject(NoveltyManager())
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: date)
}
