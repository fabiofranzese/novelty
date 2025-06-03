//
//  Untitled.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI

struct AnimatedButton: View {
    let icon: String
    let color: Color
    let targetOffset: CGSize
    let isVisible: Bool
    let isHovered: Bool

    var body: some View {
        Circle()
            .fill(isHovered ? Color.black : color)
            .frame(width: 70, height: 70)
            .overlay(Image(systemName: icon).foregroundColor(.white))
            .scaleEffect(isHovered ? 1.3 : 1.0)
            .shadow(radius: 8)
            .offset(isVisible ? targetOffset : .zero)
            .opacity(isVisible ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: isVisible)
            .animation(.easeOut(duration: 0.15), value: isHovered)
    }
}

//struct GeneralNoveltyView: View {
//    @EnvironmentObject var manager: NoveltyManager
//    @EnvironmentObject var noveltyTimerManager: NoveltyTimerManager
//    @State private var noveltytime: Double = Double.infinity
//    
//    @AppStorage("onboarding") var onboarding: Bool = false
//    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
//    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity
//    var body: some View {
//        NavigationStack {
//            
//            Text("General Novelty")
//            Text(manager.todayNovelty?.title ?? "No Novelty")
//            HStack {
//                Button("Discard") {
//                    manager.discardTodayNovelty()
//                    print("Novelty Discarded", NextNoveltyTime, NextNoveltyId)
//                }.buttonStyle(.borderedProminent)
//                Button("Accept") {
//                    noveltyTimerManager.currentNovelty = manager.todayNovelty
//                    noveltyTimerManager.startLiveActivity()
//                    manager.acceptTodayNovelty()
//                    print("Novelty accepted and done", NextNoveltyTime, NextNoveltyId)
//                }.buttonStyle(.borderedProminent)
//                Button("Delay") {
//                    NotificationManager.delayNotification()
//                    print("Notification Delayed", NextNoveltyTime, NextNoveltyId)
//                }.buttonStyle(.borderedProminent)
//            }
//            
//            Button("Reset") {
//                onboarding = false
//                NextNoveltyId = ""
//                NextNoveltyTime = Double.infinity
//            }
//            .buttonStyle(.borderedProminent)
//        }.onAppear {
//            noveltytime = NextNoveltyTime
//        }
//        .onChange(of: NextNoveltyTime) { newValue in
//            noveltytime = newValue
//        }
//    }
//}

struct GeneralNoveltyProposalView: View {
    @EnvironmentObject var manager: NoveltyManager
    @EnvironmentObject var noveltyTimerManager: NoveltyTimerManager
    @State private var noveltytime: Double = Double.infinity
    
    @AppStorage("onboarding") var onboarding: Bool = false
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity
    @GestureState private var isDetectingPress = false
    @State private var feedbackGiven = false
    @State private var dragLocation: CGPoint = .zero
    @State private var showTimer = false
    @State private var selectedMinute: Int = 0
    @State private var isPressed = false
    @State private var showSecondaryButtons = false

    @State private var hasEnteredClock = false
    @State private var hasEnteredX = false
    @State private var hasEnteredCheck = false
    
    func isHovering(over location: CGPoint, at target: CGPoint) -> Bool {
        let threshold: CGFloat = 60
        let distance = hypot(location.x - target.x, location.y - target.y)
        return distance < threshold
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {
                let center = CGPoint(x: geo.size.width / 2, y: geo.size.height - 100)
                let offsetClock = CGSize(width: 0, height: -120)
                let offsetX = CGSize(width: -120, height: -30)
                let offsetCheck = CGSize(width: 120, height: -30)
                let clockTarget = CGPoint(x: center.x + offsetClock.width, y: center.y + offsetClock.height)
                let xTarget = CGPoint(x: center.x + offsetX.width, y: center.y + offsetX.height)
                let checkTarget = CGPoint(x: center.x + offsetCheck.width, y: center.y + offsetCheck.height)

                VStack {
                    Spacer()

                    ZStack {
                        AnimatedButton(icon: "clock", color: Color.gray.opacity(0.7), targetOffset: .zero, isVisible: showSecondaryButtons, isHovered: isHovering(over: dragLocation, at: CGPoint(x: center.x + offsetClock.width, y: center.y + offsetClock.height)))
                            .position(showSecondaryButtons ? CGPoint(x: center.x + offsetClock.width, y: center.y + offsetClock.height) : center)
                            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: showSecondaryButtons)

                        AnimatedButton(icon: "xmark", color: Color.gray.opacity(0.6), targetOffset: .zero, isVisible: showSecondaryButtons, isHovered: isHovering(over: dragLocation, at: CGPoint(x: center.x + offsetX.width, y: center.y + offsetX.height)))
                            .position(showSecondaryButtons ? CGPoint(x: center.x + offsetX.width, y: center.y + offsetX.height) : center)
                            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: showSecondaryButtons)

                        AnimatedButton(icon: "checkmark", color: Color.gray.opacity(0.8), targetOffset: .zero, isVisible: showSecondaryButtons, isHovered: isHovering(over: dragLocation, at: CGPoint(x: center.x + offsetCheck.width, y: center.y + offsetCheck.height)))
                            .position(showSecondaryButtons ? CGPoint(x: center.x + offsetCheck.width, y: center.y + offsetCheck.height) : center)
                            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: showSecondaryButtons)

                        Button(action: {}) {
                            Image(systemName: "pin.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(30)
                                .background(Color.gray.opacity(0.5))
                                .clipShape(Circle())
                                .scaleEffect(isPressed ? 1.2 : 1.0)
                                .shadow(radius: 12)
                                .animation(.spring(response: 0.3, dampingFraction: 0.4), value: isPressed)
                        }
                        .position(center)
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.5)
                                .onChanged { _ in
                                    isPressed = true
                                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                                    generator.impactOccurred()
                                    showSecondaryButtons = true
                                }
                                .onEnded { _ in
                                    isPressed = false
                                }
                        )
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    dragLocation = value.location

                                    if isHovering(over: dragLocation, at: clockTarget) {
                                        if !hasEnteredClock {
                                            let generator = UIImpactFeedbackGenerator(style: .light)
                                            generator.impactOccurred()
                                            hasEnteredClock = true
                                        }
                                    } else {
                                        hasEnteredClock = false
                                    }

                                    if isHovering(over: dragLocation, at: xTarget) {
                                        if !hasEnteredX {
                                            let generator = UIImpactFeedbackGenerator(style: .light)
                                            generator.impactOccurred()
                                            hasEnteredX = true
                                            print("hovering over x")
                                        }
                                    } else {
                                        hasEnteredX = false
                                    }

                                    if isHovering(over: dragLocation, at: checkTarget) {
                                        if !hasEnteredCheck {
                                            let generator = UIImpactFeedbackGenerator(style: .light)
                                            generator.impactOccurred()
                                            hasEnteredCheck = true
                                            print("hovering over check")
                                        }
                                    } else {
                                        hasEnteredCheck = false
                                    }
                                }
                                .onEnded { value in
                                    if isHovering(over: dragLocation, at: clockTarget) {
                                        withAnimation(.easeInOut) {
                                            NotificationManager.delayNotification()
                                            print("Notification Delayed", NextNoveltyTime, NextNoveltyId)
                                            //showTimer = true
                                            print("Timer pressed")
                                        }
                                    }
                                    else if isHovering(over: dragLocation, at: xTarget) {
                                        withAnimation(.easeInOut) {
                                            manager.discardTodayNovelty()
                                            print("Novelty Discarded", NextNoveltyTime, NextNoveltyId)
                                        }
                                    } else if isHovering(over: dragLocation, at: checkTarget) {
                                        withAnimation(.easeInOut) {
                                            noveltyTimerManager.currentNovelty = manager.todayNovelty
                                            noveltyTimerManager.startLiveActivity()
                                            manager.acceptTodayNovelty()
                                            print("Novelty accepted and done", NextNoveltyTime, NextNoveltyId)
                                            print("check pressed")
                                        }
                                    }
                                    dragLocation = .zero
                                    hasEnteredClock = false
                                    hasEnteredX = false
                                    hasEnteredCheck = false
                                    showSecondaryButtons = false
                                }
                                .updating($isDetectingPress) { _, state, _ in
                                    state = true
                                }
                        )
                    }

                    Spacer().frame(height: 50)
                }


            }
        }.onAppear {
            noveltytime = NextNoveltyTime
        }
        .onChange(of: NextNoveltyTime) { newValue in
            noveltytime = newValue
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showTimer) {
            TimerSheetView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }

        }

    }


struct TimerSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var duration: TimeInterval = 60

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { Date(timeIntervalSinceNow: duration) },
                        set: { duration = $0.timeIntervalSince(Date()) }
                    ),
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 200)
                .padding()

                Text("Timer: \(Int(duration / 60)) min \(Int(duration.truncatingRemainder(dividingBy: 60))) sec")
                    .font(.headline)
                    .padding(.bottom)

                Button("Start") {
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Set Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}
