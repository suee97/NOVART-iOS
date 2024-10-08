//
//  MyPageCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

final class MyPageCoordinator: BaseStackCoordinator<MyPageStep>, LoginModalPresentableCoordinator {
    
    var userId: Int64?
    
    override func start() {
        let viewModel = MyPageMainViewModel(coordinator: self, userId: nil, repository: MyPageRepository())
        let viewController = MyPageMainViewController(viewModel: viewModel)
        
        let tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_my_deselected"),
            selectedImage: UIImage(named: "tab_my_selected")
        )
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        viewController.tabBarItem = tabBarItem
        navigator.start(viewController)
    }
    
    @MainActor
    func startAsPush(selectedCategory: MyPageCategory = .Work) {
        let viewModel = MyPageMainViewModel(coordinator: self, userId: userId, repository: MyPageRepository())
        let viewController = MyPageMainViewController(viewModel: viewModel, selectedCategory: .Following)
        viewModel.isStartAsPush = true
        navigator.push(viewController, animated: true)
    }
    
    override func navigate(to step: MyPageStep) {
        switch step {
        case .MyPageMain:
            showMain()
        case .MyPageProfileEdit:
            showProfileEdit()
        case .MyPageSetting:
            showSetting()
        case .MyPageNotification:
            showNotification()
        case .productUpload:
            showProductUploadScene()
        case .LoginModal:
            presentLoginModal()
        case .Close:
            close()
        case .login:
            presentLoginModal()
        case let .product(id):
            presentProductDetailVC(productId: id)
        case let .artist(id):
            showArtistProfile(userId: id)
        case let .exhibitionDetail(id):
            showExhibitionDetailScene(exhibitionId: id)
        case let .block(user):
            showBlockSheet(user: user)
        case let .report(userId):
            showReportSheet(userId: userId)
        case let .ask(user):
            showAskSheet(user: user)
        case .logout:
            logout()
        case let .policy(policyType):
            showPolicy(policyType: policyType)
        case .deleteUser:
            deleteUser()
        case .followList:
            showFollowList()
        }
    }
    
    @MainActor
    private func showMain() {
        navigator.pop(animated: true)
    }
    
    @MainActor
    private func showProfileEdit() {
        guard let user = Authentication.shared.user else { return }
        let viewModel = MyPageProfileEditViewModel(user: user)
        viewModel.coordinator = self
        let viewController = MyPageProfileEditViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    @MainActor
    private func showSetting() {
        let user: PlainUser? = Authentication.shared.user
        let viewModel = MyPageSettingViewModel(coordinator: self, user: user)
        let viewController = MyPageSettingViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    @MainActor
    private func showNotification() {
        let viewModel = MyPageNotificationViewModel(coordinator: self)
        let viewController = MyPageNotificationViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    @MainActor
    private func showProductUploadScene() {
        let root = BaseNavigationController()
        let productUploadStackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
        let productUploadCoordinator = ProductUploadCoordinator(navigator: productUploadStackNavigator)
        add(coordinators: productUploadCoordinator)
        productUploadCoordinator.start()
    }
    
    @MainActor
    func close() {
        navigator.pop(animated: true)
        
        if !(navigator.rootViewController.topViewController is MyPageMainViewController) && !(navigator.rootViewController.topViewController is MyPageNotificationViewController) {
            end()
        }

    }
    
    @MainActor
    private func presentProductDetailVC(productId: Int64) {
        let root = BaseNavigationController()
        let productDetailStackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
        let productDetailCoordinator = ProductDetailCoordinator(navigator: productDetailStackNavigator)
        productDetailCoordinator.productId = productId
        add(coordinators: productDetailCoordinator)
        
        productDetailCoordinator.start()
    }
    
    @MainActor
    private func showArtistProfile(userId: Int64) {
        let viewModel = MyPageMainViewModel(coordinator: self, userId: userId, repository: MyPageRepository())
        viewModel.isStartAsPush = true
        let viewController = MyPageMainViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    @MainActor
    private func showExhibitionDetailScene(exhibitionId: Int64) {
        let root = BaseNavigationController()
        let stackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
        let exhibitionDetailCoordinator = ExhibitionDetailCoordinator(navigator: stackNavigator)
        exhibitionDetailCoordinator.exhibitionId = exhibitionId
        add(coordinators: exhibitionDetailCoordinator)
        
        exhibitionDetailCoordinator.start()
    }
    
    @MainActor
    private func showBlockSheet(user: PlainUser) {
        let bottomSheetRoot = BottomSheetNavigationController()
        bottomSheetRoot.bottomSheetConfiguration.customHeight = 390
        let stackNavigator = StackNavigator(rootViewController: bottomSheetRoot, presenter: navigator.rootViewController)
        let coordinator = BlockCoordinator(navigator: stackNavigator)
        coordinator.user = user

        add(coordinators: coordinator)
        coordinator.start()
    }
    
    @MainActor
    private func showReportSheet(userId: Int64) {
        let bottomSheetRoot = BottomSheetNavigationController()
        bottomSheetRoot.bottomSheetConfiguration.customHeight = 390
        let stackNavigator = StackNavigator(rootViewController: bottomSheetRoot, presenter: navigator.rootViewController)
        let coordinator = ReportCoordinator(navigator: stackNavigator)
        coordinator.id = userId
        coordinator.reportDomain = .user
        
        add(coordinators: coordinator)
        coordinator.start()
    }
    
    @MainActor
    private func showAskSheet(user: PlainUser) {
        let bottomSheetRoot = BottomSheetNavigationController()
        bottomSheetRoot.bottomSheetConfiguration.customHeight = 248
        let stackNavigator = StackNavigator(rootViewController: bottomSheetRoot, presenter: navigator.rootViewController)
        let coordinator = AskCoordinator(navigator: stackNavigator)
        coordinator.user = user

        add(coordinators: coordinator)
        coordinator.start()
    }
    
    @MainActor
    private func logout() {
        Authentication.shared.logoutUser()
        guard let appCoordinator = UIApplication.shared.appCoordinator else { return }
        for childCoordinator in appCoordinator.childCoordinators {
            childCoordinator.end()
        }
        appCoordinator.navigate(to: .login)
    }
    
    @MainActor
    private func showPolicy(policyType: PolicyType) {
        let viewController = PolicyViewController(policyType: policyType)
        navigator.push(viewController, animated: true)
    }
    
    @MainActor
    private func deleteUser() {
        Authentication.shared.logoutUser()
        guard let appCoordinator = UIApplication.shared.appCoordinator else { return }
        for childCoordinator in appCoordinator.childCoordinators {
            childCoordinator.end()
        }
        appCoordinator.navigate(to: .login)
    }
    
    @MainActor
    private func showFollowList() {
        let myPageCoordinator = MyPageCoordinator(navigator: navigator)
        myPageCoordinator.userId = nil
        add(coordinators: myPageCoordinator)
        myPageCoordinator.startAsPush(selectedCategory: .Following)
    }
}
