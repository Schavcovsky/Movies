//
//  MockUserDefaults.swift
//  MoviesTests
//
//  Created by Alejandro Villalobos on 26-11-23.
//

import Foundation

class MockUserDefaults: UserDefaults {
    var store = [String: Any]()

    override func set(_ value: Any?, forKey key: String) {
        store[key] = value
    }

    override func data(forKey key: String) -> Data? {
        return store[key] as? Data
    }

    override func removeObject(forKey key: String) {
        store.removeValue(forKey: key)
    }
}
