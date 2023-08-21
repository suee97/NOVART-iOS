//
//  BaseViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    let isDismissed: PassthroughSubject<Bool, Never> = .init()
    let isPopped: PassthroughSubject<Bool, Never> = .init()
    
    private var className: String { Self.description().components(separatedBy: ".").last ?? "" }
    private var isDisappeared: Bool = false
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isDisappeared = true
        
        if (navigationController?.isBeingDismissed ?? false) || isBeingDismissed {
            isDismissed.send(true)
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if self.isDisappeared, parent == nil {
            self.isPopped.send(true)
        }
    }
    
    // MARK: - Setup
    func setupNavigationBar() {
    }
    
    func setupView() {
    }
    
    func setupBindings() {
    }
    
}
