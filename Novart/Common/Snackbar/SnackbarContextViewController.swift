//
//  SnackbarContextViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2/17/24.
//

import UIKit

final class SnackbarContextViewController: UIViewController {

    private lazy var snackbarView: PlainSnackbarView = {
        PlainSnackbarView(message: self.message, configuration: self.configuration)
    }()
    
    private let message: String
    private let configuration: PlainSnackbarView.Configuration?
    private let delay: Double?
    private let duration: Double?
    private var completion: (() -> Void)?
    
    required init(message: String, configuration: PlainSnackbarView.Configuration? = nil, delay: Double? = nil, duration: Double? = nil, completion: (() -> Void)? = nil) {
        self.message = message
        self.configuration = configuration
        self.delay = delay
        self.duration = duration
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = PassthroughView(frame: CGRect.zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        snackbarView.show(in: self.view, delay: delay, duration: duration, completion: self.completion)
    }
    
    func removeAll() {
        self.completion = nil
        self.view.removeFromSuperview()
    }
}

