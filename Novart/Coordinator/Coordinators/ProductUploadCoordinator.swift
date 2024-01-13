//
//  ProductUploadCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit

final class ProductUploadCoordinator: BaseStackCoordinator<ProductUploadStep>, MediaPickerPresentableCoordinator {
    
    var mediaPickerPresentable: (any MediaPickerPresentable)? { productUploadViewController }
    
    private weak var productUploadViewController: ProductUploadViewController?
    
    override func start() {
        super.start()
        let viewModel = ProductUploadViewModel(coordinator: self)
        let viewController = ProductUploadViewController(viewModel: viewModel)
        productUploadViewController = viewController
        navigator.start(viewController)
    }
    
    override func navigate(to step: ProductUploadStep) {
        switch step {
        case let .detailImage(coverImages):
            showDetailImageUpload(coverImages: coverImages)
        case let .detailInfo(coverImages, detailImage):
            showDetailInfoUpload(coverImages: coverImages, detailImage: detailImage)
        case .imageEdit:
            showImageEditScene()
        case let .preview(data):
            showPreview(data: data)
        case let .upload(data):
            showUploadScene(data: data)
        }
    }
    
    func setAsMediaPickerPresenter(viewController: ProductUploadViewController) {
        productUploadViewController = viewController
    }
    
    private func showDetailImageUpload(coverImages: [UploadMediaItem]) {
        let viewModel = ProductUploadViewModel(coordinator: self, coverImages: coverImages)
        let viewController = ProductUploadViewController(viewModel: viewModel)
        productUploadViewController = viewController
        navigator.push(viewController, animated: true)
    }

    private func showDetailInfoUpload(coverImages: [UploadMediaItem], detailImage: [UploadMediaItem]) {
        let viewModel = ProductDetailUploadViewModel(coordinator: self, selectedCoverImages: coverImages, selectedDetailImages: detailImage)
        let viewController = ProductDetailUploadViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    private func showPreview(data: ProductPreviewModel) {
        let viewModel = ProductPreviewViewModel(productPreviewData: data, coordinator: self)
        let viewController = ProductPreviewViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    private func showUploadScene(data: ProductPreviewModel) {
        let viewModel = ProductUploadingViewModel(data: data, coordinator: self)
        let viewController = ProductUploadingViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    private func showImageEditScene() {
        let viewModel = ImageEditViewModel(coordinator: self)
        let viewController = ImageEditViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigator.rootViewController.present(navigationController, animated: true)
    }
}
