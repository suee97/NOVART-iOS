//
//  SetNameViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/07.
//

import SwiftUI

class SetNameViewModel: ObservableObject {
    
    var interactor: SignInInteractor = SignInInteractor()
        
    init() {
    }
    
    func setNickname(as nickname: String) {
        Task {
            try await interactor.setNickname(as: nickname)
        }
    }
}
