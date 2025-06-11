//
//  Onboarding.swift
//  Novelty
//
//  Created by Fabio on 11/06/25.
//

import SwiftUI
import UserNotifications

struct OnboardingSlide: Identifiable {
    let id = UUID()
    let lines: [String]
    let requiresNotificationPermission: Bool
}

let onboardingSlides: [OnboardingSlide] = [
    OnboardingSlide(lines: ["hi there ;)"], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["do you ever", "feel like", "you've been..."], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["moving too fast", "thinking too fast", "scrolling too fast"], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["novelties", "is a space to", "pause.", "shift.", "see things.", "just a little differently."], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["everyday,", "when you least expect it,", "we'll offer you a", "unique prompt:", "your novelty"], requiresNotificationPermission: true),
    OnboardingSlide(lines: ["the timeframe will be different everyday,", "but always within 5 minutes"], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["it could be", "2:37.", "3:18.", "4:49.", "you will never know", "unless you open the app"], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["to accept it", "use your finger as a marker", "and fill the screen with color"], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["to get a new one", "shake your phone"], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["to discard it", "place your phone face–down on any surface"], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["after every novelty", "you'll be invited to capture the moment", "each time", "in a different way..."], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["it could be", "in five words.", "in haiku.", "in emojis."], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["no right answers", "just curious ones"], requiresNotificationPermission: false),
    OnboardingSlide(lines: ["ready to begin?", "you don't have to try hard", "you just have to", "notice!"], requiresNotificationPermission: false)
]

struct Onboarding: View {
    @State private var currentSlideIndex = 0
    @State private var visibleLines: [String] = []
    @State private var showLine = [Bool]()
    @State private var showingNotificationPrompt = false
    @State private var slideFullyDisplayed = false
    
    @AppStorage("onboarding") var onboarding = false
    @EnvironmentObject var manager : NoveltyManager
    @EnvironmentObject var timeManager: TimeManager
    
    @State private var viewcontroller: Bool = false

    let lineDelay: TimeInterval = 1

    var body: some View {
        ZStack {
            BackgroundView(color1: Color.yellow, color2: Color.orange, color3: Color.pink, color4: Color.purple)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(visibleLines.enumerated()), id: \.offset) { index, line in
                    if showLine.indices.contains(index), showLine[index] {
                        Text(line)
                            .font(.extrabold(size: 40))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.easeOut(duration: 0.5), value: showLine[index])
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            VStack{
                Spacer()
                if showingNotificationPrompt {
                    StyledButton(title: "enable notifications", action: requestNotificationPermission)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeOut(duration: 0.5))
                }
                
                if currentSlideIndex == onboardingSlides.count - 1 && !showingNotificationPrompt {
                    StyledButton(title: "get started", action: {
                        print("Get Started tapped")
                        onboarding = true
                        manager.proposeNewNovelty()
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeOut(duration: 0.5))
                }
            }.padding(.bottom, 30)
                .padding(.horizontal)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if slideFullyDisplayed && !showingNotificationPrompt {
                goToNextSlide()
            }
        }
        .onAppear {
            displayCurrentSlide()
            viewcontroller = onboarding
        }
        .onChange(of: onboarding) { newValue in
            viewcontroller = newValue
        }
    }

    func displayCurrentSlide() {
        let slide = onboardingSlides[currentSlideIndex]
        visibleLines = slide.lines
        showLine = Array(repeating: false, count: slide.lines.count)
        showingNotificationPrompt = false
        slideFullyDisplayed = false

        for i in slide.lines.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + lineDelay * Double(i)) {
                withAnimation {
                    showLine[i] = true
                }

                if i == slide.lines.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        slideFullyDisplayed = true
                        if slide.requiresNotificationPermission {
                            showingNotificationPrompt = true
                        }
                    }
                }
            }
        }
    }

    func goToNextSlide() {
        guard currentSlideIndex < onboardingSlides.count - 1 else { return }
        currentSlideIndex += 1
        visibleLines = []
        showLine = []
        displayCurrentSlide()
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                showingNotificationPrompt = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    goToNextSlide()
                    print("Notification authorized")
                }
            }
        }
    }
}

// Componente pulsante personalizzato con design migliorato
struct StyledButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .font(.bold(size: 20))
                    .foregroundStyle(Color.white)
                    .textCase(.lowercase)
                Spacer()
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 32)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.purple)
                    .opacity(0.8)
                    //.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    //.scaleEffect(isPressed ? 0.95 : 1.0)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

#Preview {
    Onboarding()
}
