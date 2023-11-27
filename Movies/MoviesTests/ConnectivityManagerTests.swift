//
//  ConnectivityManagerTests.swift
//  MoviesTests
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import XCTest
import Network
@testable import Movies

class ConnectivityManagerTests: XCTestCase {
    var connectivityManager: ConnectivityManager!
    
    class MockDelegate: ConnectivityDelegate {
        var isConnected: Bool?
        
        func didChangeConnectionStatus(connected: Bool) {
            isConnected = connected
        }
    }

    override func setUp() {
        super.setUp()
        connectivityManager = ConnectivityManager()
    }
    
    func testInitialConnectionStatus() {
        XCTAssertFalse(connectivityManager.isConnected)
    }
    
    func testStartMonitoring() {
        let mockDelegate = MockDelegate()
        connectivityManager.delegate = mockDelegate
        connectivityManager.startMonitoring()
        
        // Wait for a short time to allow the monitor to start
        let expectation = XCTestExpectation(description: "Monitor started")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(mockDelegate.isConnected ?? false)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    override func tearDown() {
        connectivityManager = nil
        super.tearDown()
    }
}
