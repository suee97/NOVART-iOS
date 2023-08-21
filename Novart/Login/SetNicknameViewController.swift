//
//  SetNicknameViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/23.
//

import UIKit
import Combine

final class SetNicknameViewController: BaseViewController {
    // MARK: - Constants
    
    enum Constants {
        enum TitleLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 20, weight: .bold)
            static let textColor: UIColor = UIColor.Common.black
            static let bottonMargin: CGFloat = 16
        }
        
        enum SubtitleLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
            static let textColor: UIColor = UIColor.Common.grey02
        }
        
        enum DoneButton {
            static let backgroundColor: UIColor = UIColor.Common.grey01
            static let textColor: UIColor = UIColor.Common.white
            static let font: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
            static let cornerRadius: CGFloat = 4
            static let height: CGFloat = 46
            static let topMargin: CGFloat = 56
        }
    }
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.TitleLabel.textColor
        label.font = Constants.TitleLabel.font
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "NOVART에서 활동할\n닉네임을 만들어주세요."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.SubtitleLabel.textColor
        label.font = Constants.SubtitleLabel.font
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "해당 닉네임은 자동 생성된 닉네임이에요\n자유롭게 바꿀 수 있어요."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료하기", for: .normal)
        button.setTitleColor(Constants.DoneButton.textColor, for: .normal)
        button.titleLabel?.font = Constants.DoneButton.font
        button.backgroundColor = Constants.DoneButton.backgroundColor
        button.layer.cornerRadius = Constants.DoneButton.cornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
        
        }), for: .touchUpInside)
        
        return button
    }()
}
