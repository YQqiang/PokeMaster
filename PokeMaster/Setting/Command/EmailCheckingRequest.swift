//
//  EmailCheckingRequest.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/20.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation
import Combine

struct EmailCheckingRequest {
    let email: String

    var publisher: AnyPublisher<Bool, Never> {
        Future<Bool, Never> { (promise) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                    if self.email == "abc@qq.com" {
                        promise(.success(false))
                    } else {
                        promise(.success(true))
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
