//
//  BackGroundView.swift
//  Novelty
//
//  Created by Fabio on 11/06/25.
//
import SwiftUI

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexSanitized.count {
        case 3: // RGB (12-bit) e.g., "FFF"
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit) e.g., "FFFFFF"
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit) e.g., "FFFFFFFF"
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // Default to black if invalid
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct BackgroundView: View {
    
    let color1: Color
    let color2: Color
    let color3: Color
    let color4: Color
    
    @State private var gradientStops: [Gradient.Stop] = []
    @State private var isAlternateState = false
    let animationDuration: Double = 3.5

    var stateAStops: [Gradient.Stop] {
        [
            .init(color: color1, location: 0.0),
            .init(color: color1, location: 0.15),
            .init(color: color2, location: 0.55),
            .init(color: color3, location: 1.0)
        ]
    }

    var stateBStops: [Gradient.Stop] {
        [
            .init(color: color4, location: 0.0),
            .init(color: color4, location: 0.15),
            .init(color: color1, location: 0.55),
            .init(color: color3, location: 1.0)
        ]
    }

    var body: some View {
        GeometryReader { geometry in
            let endRadius = max(geometry.size.width, geometry.size.height) * 0.8

            RadialGradient(
                gradient: Gradient(stops: gradientStops),
                center: .center,
                startRadius: 0,
                endRadius: endRadius
            )
            .ignoresSafeArea()
            .onAppear {
                self.gradientStops = stateAStops
                startAnimationLoop()
                print(color1.description)
            }
        }
    }

    func startAnimationLoop() {
        Task {
            while true {
                isAlternateState.toggle()
                let targetStops = isAlternateState ? stateBStops : stateAStops
                
                withAnimation(.easeInOut(duration: animationDuration)) {
                    gradientStops = targetStops
                }
                
                try? await Task.sleep(nanoseconds: UInt64(animationDuration * 1_000_000_000))
            }
        }
    }
}
