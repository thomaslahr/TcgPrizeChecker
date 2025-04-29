//
//  OnboardingBackgroundView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 21/04/2025.
//

import SwiftUI

struct OnboardingBackgroundView: View {
	
	@State private var tilt = false
	
	var body: some View {
			VStack {
				HStack {
					TcgCardVIew()
						.rotation3DEffect(
							.degrees(tilt ? 15 : -15), // small back and forth tilt
							axis: (x: 1, y: 1, z: 1), // rotate along Y axis
							anchor: .center
						)
						.animation(
							Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true),
							value: tilt
						)
					Spacer()
					TcgCardVIew()
						.rotation3DEffect(
							.degrees(tilt ? 15 : -15), // small back and forth tilt
							axis: (x: 0, y: 1, z: 1), // rotate along Y axis
							anchor: .center
						)
						.animation(
							Animation.easeInOut(duration: 2).repeatForever(autoreverses: true),
							value: tilt
						)
				}
				Spacer()
				HStack {
					TcgCardVIew()
						.rotation3DEffect(
							.degrees(tilt ? 15 : -15), // small back and forth tilt
							axis: (x: 0, y: 1, z: 1), // rotate along Y axis
							anchor: .center
						)
						.animation(
							Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true),
							value: tilt
						)
					Spacer()
					TcgCardVIew()
						.rotation3DEffect(
							.degrees(tilt ? 15 : -15), // small back and forth tilt
							axis: (x: 3, y: 1, z: 1), // rotate along Y axis
							anchor: .center
						)
						.animation(
							Animation.easeInOut(duration: 2).repeatForever(autoreverses: true),
							value: tilt
						)
				}
				Spacer()
				HStack {
					TcgCardVIew()
						.rotation3DEffect(
							.degrees(tilt ? 15 : -15), // small back and forth tilt
							axis: (x: 0, y: 1, z: 1), // rotate along Y axis
							anchor: .center
						)
						.animation(
							Animation.easeInOut(duration: 2).repeatForever(autoreverses: true),
							value: tilt
						)
					Spacer()
					TcgCardVIew()
						.rotation3DEffect(
							.degrees(tilt ? 15 : -15), // small back and forth tilt
							axis: (x: 2, y: 1, z: 1), // rotate along Y axis
							anchor: .center
						)
						.animation(
							Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true),
							value: tilt
						)
				}
			}
			.padding(30)
			.shadow(color: .green, radius: 5)
			//.foregroundStyle(GradientColors.primaryAppColor)
			.onAppear {
				tilt = true
			}
		}
}

#Preview {
    OnboardingBackgroundView()
}
