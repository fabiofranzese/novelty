//
//  FeedbackView.swift
//  Novelty
//
//  Created by Fabio on 12/06/25.
//

import SwiftUI
import UIKit

struct FeedbackView: View {
    @State private var feedbackText: String = ""
    @EnvironmentObject var manager: NoveltyManager
    @EnvironmentObject var noveltyTimerManager: NoveltyTimerManager
    @State private var noveltytime: Double = Double.infinity
    
    @AppStorage("onboarding") var onboarding: Bool = false
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity
    @StateObject private var touchObserver = FingerTouchObserver.shared

    
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                Text("\(manager.todayNovelty?.feedback?.feedbackquestion ?? "No Novelty")")
                    .font(.extrabold(size: 40))
                    .frame(alignment: .leading)
                    .foregroundStyle(.white)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 15)
                TextEditor(text: $feedbackText)
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .frame(height: 140)
                    .scrollContentBackground(.hidden)
                    .font(.bold(size: 20))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            .padding(.trailing, 40)
        }.onAppear {
            touchObserver.install()
        }
        .onChange(of: touchObserver.threeFingersDetected) { detected in
            if detected {
                hideKeyboard()
                submitFeedback()
            }
        }
        .onChange(of: touchObserver.oneFingerDetected) { detected in
            if detected {
                hideKeyboard()
            }
        }
    }
    private func submitFeedback() {
        manager.todayNovelty?.feedback?.feedbackanswer = feedbackText
        manager.doTodayNoveltyFeedback()
    }
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}
class OneFingerTouchGestureRecognizer: UIGestureRecognizer {
    var onOneFingerTouch: (() -> Void)?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let allTouches = event.allTouches else { return }

        if allTouches.count == 1 {
            onOneFingerTouch?()
        }
    }

    override func reset() {
        state = .possible
    }
}

class ThreeFingerTouchGestureRecognizer: UIGestureRecognizer {
    var onThreeFingerTouch: (() -> Void)?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let allTouches = event.allTouches else { return }

        if allTouches.count == 3 {
            onThreeFingerTouch?()
        }
    }

    override func reset() {
        state = .possible
    }
}

class FingerTouchObserver: ObservableObject {
    static let shared = FingerTouchObserver()
    @Published var oneFingerDetected = false
    @Published var threeFingersDetected = false

    private var installed = false

    func install() {
        guard !installed,
              let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first else { return }

        // One finger
        let oneRecognizer = OneFingerTouchGestureRecognizer()
        oneRecognizer.cancelsTouchesInView = false
        oneRecognizer.onOneFingerTouch = {
            DispatchQueue.main.async {
                self.oneFingerDetected = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.oneFingerDetected = false
                }
            }
        }
        window.addGestureRecognizer(oneRecognizer)

        // Three fingers
        let threeRecognizer = ThreeFingerTouchGestureRecognizer()
        threeRecognizer.cancelsTouchesInView = false
        threeRecognizer.onThreeFingerTouch = {
            DispatchQueue.main.async {
                self.threeFingersDetected = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.threeFingersDetected = false
                }
            }
        }
        window.addGestureRecognizer(threeRecognizer)

        installed = true
    }
}
