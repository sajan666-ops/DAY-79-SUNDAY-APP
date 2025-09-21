//
//  ContentView.swift
//  DiceRoller
//
//  Created by SAJAN  on 21/09/25.
//

import SwiftUI
import AVFoundation

// DiceRoller - Single-file SwiftUI app
// Drop this into a new SwiftUI App project's ContentView.swift
// Requires iOS 15+ for async/await Task sleep usage (can be adapted)

struct ContentView: View {
    @State private var leftDie = 1
    @State private var rightDie = 1
    @State private var isRolling = false
    @State private var rotationAmount: Double = 0
    @State private var scaleAmount: CGFloat = 1
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 36) {
                Text("Dice Roller")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                HStack(spacing: 24) {
                    DieView(number: leftDie)
                        .rotationEffect(.degrees(rotationAmount))
                        .scaleEffect(scaleAmount)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: rotationAmount)
                        .animation(.spring(response: 0.35, dampingFraction: 0.6), value: scaleAmount)

                    DieView(number: rightDie)
                        .rotationEffect(.degrees(-rotationAmount))
                        .scaleEffect(scaleAmount)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: rotationAmount)
                        .animation(.spring(response: 0.35, dampingFraction: 0.6), value: scaleAmount)
                }
                .padding()

                Button(action: { Task { await rollDice() } }) {
                    HStack(spacing: 12) {
                        Image(systemName: "dice.fill")
                        Text(isRolling ? "Rolling..." : "Roll")
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 28)
                    .background(.regularMaterial)
                    .cornerRadius(14)
                    .shadow(radius: 6)
                }
                .disabled(isRolling)

                Spacer()
            }
            .padding(.top, 60)
            .padding(.horizontal, 28)
        }
        .onAppear {
            // set initial dice values
            leftDie = Int.random(in: 1...6)
            rightDie = Int.random(in: 1...6)
            prepareSound()
        }
    }

    // MARK: - Rolling Logic with animation loop
    func rollDice() async {
        guard !isRolling else { return }
        isRolling = true

        // haptic
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()

        // play sound quickly
        audioPlayer?.play()

        // quick animation loop to simulate dice shuffle
        for i in 0..<10 {
            // animate rotation and scale
            await MainActor.run {
                rotationAmount = Double.random(in: 200...720) * (i.isMultiple(of: 2) ? 1 : -1)
                scaleAmount = CGFloat(Double.random(in: 0.9...1.12))

                leftDie = Int.random(in: 1...6)
                rightDie = Int.random(in: 1...6)

                generator.impactOccurred()
            }
            try? await Task.sleep(nanoseconds: 70_000_000) // 70ms
        }

        // settle final values with a slightly longer animation
        await MainActor.run {
            rotationAmount = 0
            scaleAmount = 1.0
            leftDie = Int.random(in: 1...6)
            rightDie = Int.random(in: 1...6)
        }

        // small delay so UI shows final state
        try? await Task.sleep(nanoseconds: 150_000_000)

        isRolling = false
    }

    // MARK: - Sound
    func prepareSound() {
        guard let url = Bundle.main.url(forResource: "dice-roll", withExtension: "wav") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 0.9
        } catch {
            // sound optional — ignore failure
            audioPlayer = nil
        }
    }
}

// MARK: - DieView: draws a dice face using Text + pips layout
struct DieView: View {
    let number: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .frame(width: 140, height: 140)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(lineWidth: 2)
                        .opacity(0.08)
                )

            // Use pip layout for a more authentic die look
            VStack(spacing: 8) {
                if [1,2,3,4,5,6].contains(number) {
                    pipRows(for: number)
                }
            }
            .frame(width: 108, height: 108)
        }
    }

    @ViewBuilder
    func pipRows(for n: Int) -> some View {
        switch n {
        case 1:
            CenterPip()
        case 2:
            HStack { LeadingPip(); Spacer(); TrailingPip() }
        case 3:
            VStack { TopLeadingPip(); Spacer(); CenterPip(); Spacer(); BottomTrailingPip() }
        case 4:
            VStack { HStack { LeadingPip(); Spacer(); TrailingPip() }; Spacer(); HStack { LeadingPip(); Spacer(); TrailingPip() } }
        case 5:
            VStack { HStack { LeadingPip(); Spacer(); TrailingPip() }; Spacer(); CenterPip(); Spacer(); HStack { LeadingPip(); Spacer(); TrailingPip() } }
        case 6:
            VStack { HStack { LeadingPip(); Spacer(); TrailingPip() }; Spacer(); HStack { LeadingPip(); Spacer(); TrailingPip() }; Spacer(); HStack { LeadingPip(); Spacer(); TrailingPip() } }
        default:
            CenterPip()
        }
    }

    // pip components
    struct Pip: View {
        var body: some View {
            Circle()
                .frame(width: 18, height: 18)
                .foregroundStyle(.primary)
                .opacity(0.9)
        }
    }
    @ViewBuilder func CenterPip() -> some View { HStack { Spacer(); Pip(); Spacer() } }
    @ViewBuilder func LeadingPip() -> some View { Pip() }
    @ViewBuilder func TrailingPip() -> some View { Pip() }
    @ViewBuilder func TopLeadingPip() -> some View { HStack { LeadingPip(); Spacer() } }
    @ViewBuilder func BottomTrailingPip() -> some View { HStack { Spacer(); TrailingPip() } }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 14")
    }
}
