//
//  ProductUploadCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit
import CropViewController

final class ProductUploadCoordinator: BaseStackCoordinator<ProductUploadStep>, MediaPickerPresentableCoordinator, ImageEditorPresentableCoordinator {
    
    var mediaPickerPresentable: (any MediaPickerPresentable)? { productUploadViewController }
  
    var imageEditManager: ImageEditManager = .init()
    
    private weak var productUploadViewController: ProductImageUploadViewController?
    
    var productModel: ProductUploadModel?
    
    override func start() {
        super.start()
        let viewModel = ProductImageUploadViewModel(coordinator: self, step: .coverImage)
        let viewController = ProductImageUploadViewController(viewModel: viewModel)
        productUploadViewController = viewController
        navigator.start(viewController)
    }
    
    @MainActor
    func startAsPush() {
        let viewModel = ProductImageUploadViewModel(coordinator: self, step: .coverImage, uploadModel: productModel)
        let viewController = ProductImageUploadViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    override func navigate(to step: ProductUploadStep) {
        switch step {
        case let .detailImage(productModel):
            showDetailImageUpload(productModel: productModel)
        case let .detailInfo(productModel):
            showDetailInfoUpload(productModel: productModel)
        case let .imageEdit(image):
            showImageEditScene(image: image)
        case let .preview(data, productModel):
            showPreview(data: data, productModel: productModel)
        case let .upload(data):
            showUploadScene(data: data)
        case let .cancelAlert(isEditScene):
            showCancelAlert(isEditScene: isEditScene)
        case let .product(id):
            showProductDetail(productId: id)
        }
    }
    
    func setAsMediaPickerPresenter(viewController: ProductImageUploadViewController) {
        productUploadViewController = viewController
    }
    
    @MainActor
    private func showDetailImageUpload(productModel: ProductUploadModel) {
        let viewModel = ProductImageUploadViewModel(coordinator: self, step: .detailImage, uploadModel: productModel)
        let viewController = ProductImageUploadViewController(viewModel: viewModel)
        productUploadViewController = viewController
        navigator.push(viewController, animated: true)
    }

    @MainActor
    private func showDetailInfoUpload(productModel: ProductUploadModel) {
        let viewModel = ProductInfoUploadViewModel(coordinator: self, uploadModel: productModel)
        let viewController = ProductInfoUploadViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    @MainActor
    private func showPreview(data: ProductPreviewModel, productModel: ProductUploadModel) {
        let viewModel = ProductPreviewViewModel(productPreviewData: data, productModel: productModel, coordinator: self)
        let viewController = ProductPreviewViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    @MainActor
    private func showUploadScene(data: ProductPreviewModel) {
        let viewModel = ProductUploadingViewModel(data: data, coordinator: self)
        let viewController = ProductUploadingViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    private func showImageEditScene(image: UploadMediaItem) {
        showImageEditor(using: image.image, presenter: navigator.rootViewController) { [weak self] croppedImage in
            guard let self else { return }
            self.productUploadViewController?.didFinishImageCrop(image: croppedImage, identifier: image.identifier)
        }
    }
    
    @MainActor
    private func showCancelAlert(isEditScene: Bool) {
        let title = isEditScene ? "작품 편집을 중단하시겠어요?" : "작품 등록을 종료하시겠어요?"
        let message = isEditScene ? "편집한 정보가 반영되지 않습니다." : "작품이 저장되지 않습니다."
        
        let alertController = AlertController(title: title, message: message, preferredStyle: .alert)
        let keepGoingAction = AlertAction(title: "이어서 편집", style: .default, handler: nil)
        let terminatingAction = AlertAction(title: "종료", style: .destructive, handler: { [weak self] _ in
            if isEditScene {
                self?.closeAsPop()
            } else {
                self?.close()
            }
        })
        
        alertController.addAction(keepGoingAction)
        alertController.addAction(terminatingAction)
        alertController.show()
    }
    
    @MainActor
    private func showProductDetail(productId: Int64) {
        self.close { [weak self] in
            guard let self, let parentCoordinator = self.parentCoordinator , let navigator = parentCoordinator.navigator as? StackNavigator else { return }
            let root = BaseNavigationController()
            let productDetailStackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
            let productDetailCoordinator = ProductDetailCoordinator(navigator: productDetailStackNavigator)
            productDetailCoordinator.productId = productId
            parentCoordinator.add(coordinators: productDetailCoordinator)
            productDetailCoordinator.start()
        }
    }
}
