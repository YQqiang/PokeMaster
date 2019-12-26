//
//  PasswordCheckingRequest.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/26.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation
import Combine

struct PasswordCheckingRequest {
    let password: String
    let verifyPassword: String

    var publisher: AnyPublisher<Bool, Never> {
        Future<Bool, Never> { (promise) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                if self.password.count <= 0 {
                    promise(.success(false))
                }
                if self.verifyPassword.count <= 0 {
                    promise(.success(false))
                }
                promise(.success(self.password == self.verifyPassword))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
