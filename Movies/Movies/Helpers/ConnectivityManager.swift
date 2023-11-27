//
//  ConnectivityManager.swift
//  Movies
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import Network

protocol ConnectivityDelegate: AnyObject {
    func didChangeConnectionStatus(connected: Bool)
}

class ConnectivityManager {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ConnectivityMonitor")
    weak var delegate: ConnectivityDelegate?
    
    private(set) var isConnected: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnectedNow = path.status == .satisfied
            DispatchQueue.main.async {
                if self?.isConnected != isConnectedNow {
                    self?.delegate?.didChangeConnectionStatus(connected: isConnectedNow)
                }
                self?.isConnected = isConnectedNow
            }
        }
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    deinit {
        stopMonitoring()
    }
}
