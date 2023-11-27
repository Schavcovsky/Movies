//
//  MockURLSession.swift
//  Movies
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import Foundation

class MockURLSession: URLSession {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = mockData
        let response = mockResponse
        let error = mockError
        return MockURLSessionDataTask {
            completionHandler(data, response, error)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
