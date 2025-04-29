//
//  AppBackGroundView.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 26/04/2025.
//

import SwiftUI

struct AppBackGroundView: View {
    var body: some View {
		VStack {
			HStack {
				TcgCardVIew()
					.scaleEffect(0.5)
					.rotation3DEffect(
						.degrees(15), // small back and forth tilt
						axis: (x: 1, y: -1, z: 2), // rotate along Y axis
						anchor: .center
					)
				TcgCardVIew()
					.scaleEffect(0.5)
					.rotation3DEffect(
						.degrees(15), // small back and forth tilt
						axis: (x: 1, y: -1, z: 2), // rotate along Y axis
						anchor: .center
					)
				
				TcgCardVIew()
					.scaleEffect(0.5)
					.rotation3DEffect(
						.degrees(15), // small back and forth tilt
						axis: (x: 1, y: -1, z: 2), // rotate along Y axis
						anchor: .center
					)
			}
			HStack {
				TcgCardVIew()
					.scaleEffect(0.5)
					.rotation3DEffect(
						.degrees(15), // small back and forth tilt
						axis: (x: 1, y: -1, z: 2), // rotate along Y axis
						anchor: .center
					)
				TcgCardVIew()
					.scaleEffect(0.5)
					.rotation3DEffect(
						.degrees(15), // small back and forth tilt
						axis: (x: 1, y: -1, z: 2), // rotate along Y axis
						anchor: .center
					)
				
				TcgCardVIew()
					.scaleEffect(0.5)
					.rotation3DEffect(
						.degrees(15), // small back and forth tilt
						axis: (x: 1, y: -1, z: 2), // rotate along Y axis
						anchor: .center
					)
			}
			HStack {
				TcgCardVIew()
					.scaleEffect(0.5)
					.rotation3DEffect(
						.degrees(15), // small back and forth tilt
						axis: (x: 1, y: -1, z: 2), // rotate along Y axis
						anchor: .center
					)
				TcgCardVIew()
					.scaleEffect(0.5)
					.rotation3DEffect(
						.degrees(15), // small back and forth tilt
						axis: (x: 1, y: -1, z: 2), // rotate along Y axis
						anchor: .center
					)
				
				TcgCardVIew()
					.scaleEffect(0.5)
					.rotation3DEffect(
						.degrees(15), // small back and forth tilt
						axis: (x: 1, y: -1, z: 2), // rotate along Y axis
						anchor: .center
					)
			}
			
		}
    }
}

#Preview {
    AppBackGroundView()
}
