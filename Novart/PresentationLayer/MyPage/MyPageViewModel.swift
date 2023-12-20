import Combine
import UIKit

final class MyPageViewModel {
    var coordinator: MyPageCoordinator?
//    private var interactor = MyPageDownloadInteractor()
    
    @Published private (set) var selectedCategory: MyPageCategory
    @Published private (set) var scrollHeight: Double
    
    var interests = [ProductModel]()
    var followings = [ArtistModel]()
    var works = [MyPageWork]()
    var exhibitions = [MyPageExhibition]()
    
    init(coordinator: MyPageCoordinator) {
        print("MyPageViewModel init()")
        self.coordinator = coordinator
        selectedCategory = .Interest
        scrollHeight = 0.0
    }
    
    deinit {
        print("MyPageViewModel deinit()")
    }
    
    func setCategory(_ category: MyPageCategory) {
        selectedCategory = category
    }
    
    func setScrollHeight(_ height: Double) {
        scrollHeight = height
    }
    
    func getUserInfo() {
        print("MyPageViewModel getUserInfo()")
        // 서버에서 background url, tag 등 가져오기
        
//        Task {
//            do {
//                let user = try await interactor.fetchUserInfo()
//                print(user)
//            } catch {
//                print(error)
//            }
//        }
    }
    
    func getAllItems() {
        print("MyPageViewModel getAllItems()")
        // 서버에서 가져오기 (이미지 불러오기 x)
        // 아래는 임시 데이터
//        for i in 0..<10 {
//            interests.append(MyPageInterest(id: i, name: "탁자", thumbnailImgUrl: "https://fastly.picsum.photos/id/190/200/300.jpg?hmac=KMqZBOcb2v614PnLYdaZ_nsWFhVgoZrNcnRAiytDbVc", artistName: "오승언"))
//        }
        
        for i in 0..<10 {
            interests.append(ProductModel(id: Int64(i), name: "탁자", artistNickname: "진욱", thumbnailImageUrl: "https://fastly.picsum.photos/id/190/200/300.jpg?hmac=KMqZBOcb2v614PnLYdaZ_nsWFhVgoZrNcnRAiytDbVc"))
        }
        for i in 0..<4 {
            followings.append(ArtistModel(id: Int64(i+100), nickname: "오승언", backgroundImgUrl: "https://www.fcbarcelona.com/photo-resources/2021/08/09/c4f2dddd-2152-4b8b-acf8-826b4377e29d/Camp-Nou-4.jpg?width=2400&height=1500", profileImgUrl: "https://fcb-abj-pre.s3.amazonaws.com/img/jugadors/MESSI.jpg"))
        }
        for i in 0..<3 {
            works.append(MyPageWork(id: Int64(i), name: "책 표지", thumbnailImgUrl: "https://www.fcbarcelona.com/photo-resources/2021/08/09/c4f2dddd-2152-4b8b-acf8-826b4377e29d/Camp-Nou-4.jpg?width=2400&height=1500", artistName: "오승언"))
        }
        for i in 0..<40 {
            exhibitions.append(MyPageExhibition(id: Int64(i+500), name: "공예", thumbnailImgUrl: "https://www.thesun.co.uk/wp-content/uploads/2019/11/NINTCHDBPICT000533181925.jpg?w=1240", artistName: "김예원"))
        }
    }
    
    
    // MARK: - Navigate
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
}
