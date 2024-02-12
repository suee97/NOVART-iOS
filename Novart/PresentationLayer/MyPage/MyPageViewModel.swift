import Combine
import UIKit
import Alamofire

final class MyPageViewModel {
    var coordinator: MyPageCoordinator?
    private var interactor = MyPageDownloadInteractor()
    
    @Published private (set) var selectedCategory: MyPageCategory = .Interest
    @Published private (set) var scrollHeight: Double = 0.0
    
    @Published var interests = [ProductModel]()
    @Published var followings = [ArtistModel]()
    @Published var works = [MyPageWork]()
    @Published var exhibitions = [MyPageExhibition]()
    var isInterestsEmpty = false
    var isFollowingsEmpty = false
    
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
//        for i in 1...20 {
//            if i == 1 || i == 2 {
//                interests.append(ProductModel(id: 0, name: "---?????---", artistNickname: "승언", thumbnailImageUrl: "https://imgnews.pstatic.net/image/311/2024/01/10/0001679824_001_20240110120004024.png?type=w647"))
//            } else {
//                interests.append(ProductModel(id: 0, name: "abcde", artistNickname: "승언", thumbnailImageUrl: "https://imgnews.pstatic.net/image/311/2024/01/10/0001679824_001_20240110120004024.png?type=w647"))
//            }
//        }
//        for _ in 1...20 {
//            followings.append(ArtistModel(id: 1, nickname: "dd", backgroundImageUrl: "https://imgnews.pstatic.net/image/311/2024/01/10/0001679824_001_20240110120004024.png?type=w647", profileImageUrl: "https://imgnews.pstatic.net/image/311/2024/01/10/0001679824_001_20240110120004024.png?type=w647"))
//        }
//        for _ in 1...20 {
//            works.append(MyPageWork(id: 0, name: "??", thumbnailImageUrl: "https://imgnews.pstatic.net/image/311/2024/01/10/0001679824_001_20240110120004024.png?type=w647", nickname: "safdsfd"))
//        }
//        for _ in 1...20 {
//            exhibitions.append(MyPageExhibition(id: 0, name: "000---", thumbnailImgUrl: "https://imgnews.pstatic.net/image/311/2024/01/10/0001679824_001_20240110120004024.png?type=w647", artistName: "me"))
//        }
    }
    
    func setCategory(_ category: MyPageCategory) {
        selectedCategory = category
    }
    
    func setScrollHeight(_ height: Double) {
        scrollHeight = height
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
                
                (self.interests, self.followings, self.works, self.exhibitions) = try await (interestsTask, followingsTask, worksTask, exhibitionsTask)
                
                
                if self.interests.isEmpty && userState == .me {
                    isInterestsEmpty = true
                    self.interests = try await interactor.fetchRecommendInterests()
                }
                
                if self.followings.isEmpty && userState == .me {
                    isFollowingsEmpty = true
                    self.followings = try await interactor.fetchRecommendFollowings()
                }
                
                if self.userState == .other {
                    setCategory(.Work)
                } else {
                    setCategory(.Interest)
                }
//                for _ in 1...20 {
//                    works.append(MyPageWork(id: 2, name: "ㅎㅎㅎ", thumbnailImageUrl: "https://imgnews.pstatic.net/image/311/2024/01/10/0001679824_001_20240110120004024.png?type=w647", nickname: "safdsfd"))
//                }
//                for _ in 1...20 {
//                    exhibitions.append(MyPageExhibition(id: 1, name: "000---", thumbnailImgUrl: "https://imgnews.pstatic.net/image/311/2024/01/10/0001679824_001_20240110120004024.png?type=w647", artistName: "me"))
//                }
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
}

enum MyPageUserState {
    case other // 로그인 유무 상관X + 다른 유저 프로필
    case loggedOut // 로그인X + 마이페이지
    case me // 로그인O + 마이페이지
}
