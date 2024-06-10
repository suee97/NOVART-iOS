import Combine
import UIKit
import Alamofire

final class MyPageViewModel {
    weak var coordinator: MyPageCoordinator?
    private var interactor = MyPageDownloadInteractor()
    
    @Published var selectedCategory: MyPageCategory = .Work
    @Published private (set) var scrollHeight: Double = 0.0
    
    @Published var interests = [ProductModel]()
    @Published var followings = [ArtistModel]()
    @Published var works = [MyPageWork]()
    @Published var exhibitions = [ExhibitionModel]()
    var isInterestsEmpty = false
    var isFollowingsEmpty = false
    var isStartAsPush = false
    var isInitialLoadFinished = false
    var notificationCheckStatusSubject = PassthroughSubject<NotificationCheckStatus, Never>()
    
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
    init(coordinator: MyPageCoordinator, userId: Int64? = nil) {
        self.coordinator = coordinator
        self.userId = userId
    }
    
    func setCategory(_ category: MyPageCategory) {
        selectedCategory = category
    }
    
    func setScrollHeight(_ height: Double) {
        scrollHeight = height
    }
    
    func isUserCanContact(openChatUrl: String?, email: String?) -> Bool {
        if let openChatUrl, !openChatUrl.isEmpty { return true }
        if let email, !email.isEmpty { return true }
        return false
    }
}


// MARK: API
extension MyPageViewModel {
    
    @MainActor
    func getAllItems() {
        var uid: Int64? = nil
        switch userState {
        case .loggedOut:
            return
        case .me:
            uid = Authentication.shared.user?.id
        case .other:
            uid = self.userId
        }
        
        guard let uid else { return }
        
        Task {
            do {
                async let interestsTask = interactor.fetchMyPageInterests(userId: uid)
                async let followingsTask = interactor.fetchMyPageFollowings(userId: uid)
                async let worksTask = interactor.fetchMyPageWorks(userId: uid)
                async let exhibitionsTask = interactor.fetchMyPageExhibitions(userId: uid)
                
                var interests = [ProductModel]()
                var followings = [ArtistModel]()
                var works = [MyPageWork]()
                var exhibitions = [ExhibitionModel]()
                
                (interests, followings, works, exhibitions) = try await (interestsTask, followingsTask, worksTask, exhibitionsTask)
                
                if interests.isEmpty {
                    isInterestsEmpty = true
                    if userState == .me {
                        interests = try await interactor.fetchRecommendInterests()
                    }
                } else {
                    isInterestsEmpty = false
                }
                
                if followings.isEmpty {
                    isFollowingsEmpty = true
                    if userState == .me {
                        followings = try await interactor.fetchRecommendFollowings()
                    }
                } else {
                    isFollowingsEmpty = false
                }
                
                self.interests = interests
                self.followings = followings
                self.works = works
                self.exhibitions = exhibitions
                
                if userState == .me {
                    let notificationCheckStatus = try await interactor.fetchNotificationCheckStatus()
                    notificationCheckStatusSubject.send(notificationCheckStatus)
                }
                
                if !isInitialLoadFinished {
                    isInitialLoadFinished = true
//                    setCategory(.Work)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getOtherUserInfo() {
        guard let userId else { return }
        Task {
            do {
                otherUser = try await interactor.fetchMyPageUserInfo(userId: userId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func follow(userId: Int64) async throws -> EmptyResponseModel {
        try await interactor.follow(userId: userId)
    }
    
    func unFollow(userId: Int64) async throws -> EmptyResponseModel {
        try await interactor.unFollow(userId: userId)
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

// MARK: Navigation
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
}

enum MyPageUserState {
    case other // 로그인 유무 상관X + 다른 유저 프로필
    case loggedOut // 로그인X + 마이페이지
    case me // 로그인O + 마이페이지
}
