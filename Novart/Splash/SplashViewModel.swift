//
//  SplashViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/18.
//

import Foundation
import Combine

class SplashViewModel: ObservableObject {
    
    var isLoginSuccess: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
    
    let interactor: SplashLoginInteractor = SplashLoginInteractor()
    
    func login() {
        Task {
            do {
                let success = try await interactor.loginIfUserExists()
                DispatchQueue.main.async { [weak self] in
                    self?.isLoginSuccess.send(success)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.isLoginSuccess.send(false)
                }
            }
        }
    }
}
