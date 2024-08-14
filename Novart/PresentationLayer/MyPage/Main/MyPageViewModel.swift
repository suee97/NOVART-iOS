import Combine
import UIKit
import Alamofire

enum MyPageUserState {
    case me // 로그인O + 마이페이지
    case other// 로그인 유무 상관X + 다른 유저 프로필
    case loggedOut // 로그인X + 마이페이지
}

final class MyPageViewModel {
    private weak var coordinator: MyPageCoordinator?
    
    @Published private(set) var selectedCategory: MyPageCategory = .Work
    var interests = [ProductModel]()
    var followings = [ArtistModel]()
    var works = [MyPageWork]()
    var exhibitions = [ExhibitionModel]()
    var shouldReloadCollectionViewSubject = PassthroughSubject<Bool, Never>()
    var isInterestsEmpty = false
    var isFollowingsEmpty = false
    var isStartAsPush = false
    var isInitialLoadFinished = false
    var notificationCheckStatusSubject = PassthroughSubject<NotificationCheckStatus, Never>()
    private let fetchNotificationCheckStatusUseCase: FetchNotificationCheckStatusUseCase
    private let fetchAllCategoryContentsUseCase: FetchAllCategoryContentsUseCase
    private let fetchRecommendInterestsUseCase: FetchRecommendInterestsUseCase
    private let fetchRecommendFollowingsUseCase: FetchRecommendFollowingsUseCase
    private let followUseCase: FollowUseCase
    private let unFollowUseCase: UnFollowUseCase
    private let fetchUserInfoUseCase: FetchUserInfoUseCase
    
    let userId: Int64?
    @Published var otherUser: PlainUser?
    
    var userState: MyPageUserState {
        if userId == nil {
            if Authentication.shared.user == nil {
                return .loggedOut
            } else {
                return .me
            }
        } else {
            return .other
        }
    }
    
    // userId가 nil인 경우: 마이페이지로 접근
    // userId가 nil이 아닌 경우: 다른 유저의 프로필 접근
    init(coordinator: MyPageCoordinator, userId: Int64? = nil, repository: MyPageRepositoryInterface) {
        self.coordinator = coordinator
        self.userId = userId
        self.fetchNotificationCheckStatusUseCase = .init(repository: repository)
        self.fetchAllCategoryContentsUseCase = .init(repository: repository)
        self.fetchRecommendInterestsUseCase = .init(repository: repository)
        self.fetchRecommendFollowingsUseCase = .init(repository: repository)
        self.followUseCase = .init(repository: repository)
        self.unFollowUseCase = .init(repository: repository)
        self.fetchUserInfoUseCase = .init(repository: repository)
    }
}

extension MyPageViewModel {
    func setCategory(_ category: MyPageCategory) {
        selectedCategory = category
    }
    
    func isUserCanContact(openChatUrl: String?, email: String?) -> Bool {
        if let openChatUrl, !openChatUrl.isEmpty { return true }
        if let email, !email.isEmpty { return true }
        return false
    }
    
    func setupData() {
        let userId = getUserId()
        guard let userId else { return }
        Task {
            do {
                try await fetchAllCategoryContents(userId: userId)
                try await fetchRecommendInterestContentsIfNeeded()
                try await fetchRecommendFollowingContentsIfNeeded()
                try await fetchNotificationCheckStatusIfNeeded()
                changeInitialLoadFlagIfNeeded()
                shouldReloadCollectionViewSubject.send(true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getUserId() -> Int64? {
        switch userState {
        case .me:
            return Authentication.shared.user?.id
        case .other:
            return userId
        case .loggedOut:
            return nil
        }
    }
    
    private func fetchAllCategoryContents(userId: Int64?) async throws {
        guard let userId else { return }
        let allCategoryContents = try await fetchAllCategoryContentsUseCase.execute(userId: userId)
        (self.interests, self.followings, self.works, self.exhibitions) = (allCategoryContents.interests, allCategoryContents.followings, allCategoryContents.works, allCategoryContents.exhibitions)
    }
    
    private func fetchRecommendInterestContentsIfNeeded() async throws {
        isInterestsEmpty = interests.isEmpty
        if isInterestsEmpty && userState == .me {
            interests = try await fetchRecommendInterestsUseCase.execute()
        }
    }
    
    private func fetchRecommendFollowingContentsIfNeeded() async throws {
        isFollowingsEmpty = followings.isEmpty
        if isFollowingsEmpty && userState == .me {
            followings = try await fetchRecommendFollowingsUseCase.execute()
        }
    }
    
    private func fetchNotificationCheckStatusIfNeeded() async throws {
        if userState == .me {
            let notificationCheckStatus = try await fetchNotificationCheckStatusUseCase.execute()
            notificationCheckStatusSubject.send(notificationCheckStatus)
        }
    }
    
    private func changeInitialLoadFlagIfNeeded() {
        if !isInitialLoadFinished {
            isInitialLoadFinished = true
        }
    }
    
    func fetchOtherUserInfo() {
        guard let userId else { return }
        Task {
            do {
                otherUser = try await fetchUserInfoUseCase.execute(userId: userId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func onTapFollowButton() {
        Task.detached { [weak self] in
            guard let self else { return }
            let isLoggedIn = Authentication.shared.isLoggedIn
            guard isLoggedIn, let otherUser else { return }
            if otherUser.following {
                let _ = try await unFollow(userId: otherUser.id)
                fetchOtherUserInfo()
            } else {
                let _ = try await follow(userId: otherUser.id)
                fetchOtherUserInfo()
                await showFollowSnackBar()
            }
        }
    }
    
    private func showFollowSnackBar() async {
        await MainActor.run {
            PlainSnackbar.show(message: "새로운 작가를 팔로우했어요!", configuration: .init(imageType: .icon(.check), buttonType: .text("모두 보기"), buttonAction: { [weak self] in
                guard let self else { return }
                self.showFollowList()
            }))
        }
    }
    
    private func follow(userId: Int64) async throws {
        let _ = try await followUseCase.execute(userId: userId)
    }
    
    private func unFollow(userId: Int64) async throws {
        let _ = try await unFollowUseCase.execute(userId: userId)
    }
    
    func getItemCount() -> Int {
        switch selectedCategory {
        case .Interest:
            return interests.count
        case .Following:
            return followings.count
        case .Work:
            return works.count
        case .Exhibition:
            return exhibitions.count
        }
    }
}

extension MyPageViewModel {
    @MainActor
    func showProfileEdit() {
        coordinator?.navigate(to: .MyPageProfileEdit)
    }
    
    @MainActor
    func showSetting() {
        coordinator?.navigate(to: .MyPageSetting)
    }
    
    @MainActor
    func showNotification() {
        coordinator?.navigate(to: .MyPageNotification)
    }
    
    @MainActor
    func showProductUploadScene() {
        coordinator?.navigate(to: .productUpload)
    }
    
    @MainActor
    func showLoginModal() {
        coordinator?.navigate(to: .LoginModal)
    }
    
    @MainActor
    func close() {
        coordinator?.navigate(to: .Close)
    }
    
    @MainActor
    func presentProductDetailScene(productId: Int64) {
        coordinator?.navigate(to: .product(productId))
    }
    
    @MainActor
    func showArtistProfile(userId: Int64) {
        coordinator?.navigate(to: .artist(userId))
    }
    
    @MainActor
    func showExhibitionDetail(exhibitionId: Int64) {
        coordinator?.navigate(to: .exhibitionDetail(id: exhibitionId))
    }
    
    @MainActor
    func showBlockSheet() {
        guard let userId,
              userState == .other,
              let otherUser else { return }
        coordinator?.navigate(to: .block(user: otherUser))
    }
    
    @MainActor
    func showReportSheet() {
        guard let userId,
        userState == .other else { return }
        coordinator?.navigate(to: .report(userId: userId))
    }
    
    @MainActor
    func showAskSheet() {
        if userState == .loggedOut {
            coordinator?.navigate(to: .login)
            return
        }
        if userState == .me { return }
        guard let user = otherUser else { return }
        
        if isUserCanContact(openChatUrl: user.openChatUrl, email: user.email) {
            coordinator?.navigate(to: .ask(user: user))
        }
    }
    
    @MainActor
    private func showFollowList() {
        coordinator?.navigate(to: .followList)
    }
}
