//
//  GradientColors.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 16/04/2025.
//

import SwiftUI

enum GradientColors: Equatable {
	static let primaryAppColor = LinearGradient(colors: [.appBlue, .appGreen], startPoint: .leading, endPoint: .trailing)
	
	static let gray = LinearGradient(colors: [.gray], startPoint: .top, endPoint: .bottom)
}

