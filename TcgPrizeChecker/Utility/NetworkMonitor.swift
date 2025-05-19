//
//  NetworkMonitor.swift
//  TcgPrizeChecker
//
//  Created by Thomas Lahr on 16/05/2025.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
	@Published var isConnected = false
	
	private let monitor = NWPathMonitor()
	private let queue = DispatchQueue(label: "NetworkMonitor")
	
	init() {
		monitor.pathUpdateHandler = { [weak self] path in
			DispatchQueue.main.sync {
				self?.isConnected = path.status == .satisfied
			}
		}
			monitor.start(queue: queue)
		}
	}
