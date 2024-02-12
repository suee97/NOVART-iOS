//
//  MediaPickerPresentable.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit

protocol MediaAuthorizationRequestable { }

extension MediaAuthorizationRequestable {
    @MainActor
    func showMediaPickerAuthorizationAlert() {
        
        let alert = UIAlertController(title: "사진 접근 권한", message: "Openlink에서 사진 첨부 및 저장을 원하시는 경우 '설정'을 눌러 '사진'권한을 허용해주세요.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "설정", style: .default) { _ in
            if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingURL)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        let currentViewController = UIApplication.getTopViewController()
        currentViewController?.present(alert, animated: true)
    }
}

protocol MediaPickerPresentable: MediaAuthorizationRequestable where Self: UIViewController {
    var mediaPicker: MediaPickerController { get }
}

extension MediaPickerPresentable {
    func showMediaPicker(preselectedIdentifiers: [String]? = nil, selectionLimit: Int? = nil, mediaPickerSelectionBlock: @escaping ((MediaPickerSelection) -> Void)) {
        Task { @MainActor in
            if preselectedIdentifiers == nil && selectionLimit == nil {
                await presentMediaPicker(mediaPickerSelectionBlock: mediaPickerSelectionBlock)
                return
            }

            var configuration = mediaPicker.configuration
            if let preselectedIdentifiers {
                configuration.preselectedAssetIdentifiers = preselectedIdentifiers
            }
            if let selectionLimit {
                configuration.selectionLimit = selectionLimit
            }
            mediaPicker.reconfigure(configuration: configuration)
            await presentMediaPicker(mediaPickerSelectionBlock: mediaPickerSelectionBlock)
        }
    }
    
    @MainActor
    private func presentMediaPicker(mediaPickerSelectionBlock: @escaping ((MediaPickerSelection) -> Void)) async {
        mediaPicker.mediaPickerSelectionBlock = mediaPickerSelectionBlock
        if await !mediaPicker.present(on: self, animated: true) {
            showMediaPickerAuthorizationAlert()
        }
    }
}

protocol MediaPickerPresentableCoordinator {
    var mediaPickerPresentable: (any MediaPickerPresentable)? { get }
}

extension MediaPickerPresentableCoordinator {
    func showMediaPicker(preselectedIdentifiers: [String]? = nil, selectionLimit: Int? = nil, mediaPickerSelectionBlock: @escaping ((MediaPickerSelection) -> Void)) {
        mediaPickerPresentable?.showMediaPicker(preselectedIdentifiers: preselectedIdentifiers, selectionLimit: selectionLimit, mediaPickerSelectionBlock: mediaPickerSelectionBlock)
    }
}
