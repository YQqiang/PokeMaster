//
//  RegisterRequest.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/26.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation
import Combine

struct RegisterRequest {
    let email: String
    let password: String
    
    var publisher: AnyPublisher<User, AppError> {
        Future { (promise) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                let user = User(email: self.email, favoritePokemonIDs: [])
                promise(.success(user))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
