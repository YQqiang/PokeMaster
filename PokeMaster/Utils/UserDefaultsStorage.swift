//
//  UserDefaultsStorage.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/20.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation

@propertyWrapper struct UserDefaultsStorage<T> {

    var value: T

    let key: String
    let defaultValue: T

    init(key: String, defaultValue: T) {
        value = UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get { value }
        set {
            if let optionalValue = newValue as? OptionalProtocol, optionalValue.isNil {
                UserDefaults.standard.removeObject(forKey: key)
                value = defaultValue
            } else {
                UserDefaults.standard.setValue(value, forKey: key)
                UserDefaults.standard.synchronize()
                value = newValue
            }
        }
    }
}

fileprivate protocol OptionalProtocol {
    var isNil: Bool { get }
}

extension Optional: OptionalProtocol {
    var isNil: Bool {
        return true
    }
}
