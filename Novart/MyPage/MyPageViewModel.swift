import Combine
import UIKit

final class MyPageViewModel {
    @Published private (set) var selectedCategory: MyPageCategory! {
        didSet {
            print("MyPageViewModel selectedCategory - \(selectedCategory.rawValue)")
        }
    }
    
    var interests = [MyPageInterest]()
    var followings = [MyPageFollowing]()
    var works = [MyPageWork]()
    var exhibitions = [MyPageExhibition]()
    
    init() {
        print("MyPageViewModel init()")
        selectedCategory = .Interest
    }
    
    deinit {
        print("MyPageViewModel deinit()")
    }
    
    func setCategory(_ category: MyPageCategory) {
        selectedCategory = category
    }
    
    func getUserInfo() {
        print("MyPageViewModel getUserInfo()")
        // 서버에서 background url, tag 등 가져오기
        
    }
    
    func getAllItems() {
        print("MyPageViewModel getAllItems()")
        // 서버에서 가져오기 (이미지 불러오기 x)
        // 아래는 임시 데이터
        for i in 0..<10 {
            interests.append(MyPageInterest(id: i, name: "탁자", thumbnailImgUrl: "https://fastly.picsum.photos/id/190/200/300.jpg?hmac=KMqZBOcb2v614PnLYdaZ_nsWFhVgoZrNcnRAiytDbVc", artistName: "오승언"))
        }
        for i in 0..<0 {
            followings.append(MyPageFollowing(id: i, name: "의자", thumbnailImgUrl: "https://fastly.picsum.photos/id/190/200/300.jpg?hmac=KMqZBOcb2v614PnLYdaZ_nsWFhVgoZrNcnRAiytDbVc", artistName: "오승언"))
        }
        for i in 0..<3 {
            works.append(MyPageWork(id: i, name: "책 표지", thumbnailImgUrl: "https://fastly.picsum.photos/id/190/200/300.jpg?hmac=KMqZBOcb2v614PnLYdaZ_nsWFhVgoZrNcnRAiytDbVc", artistName: "양용수"))
        }
        for i in 0..<40 {
            exhibitions.append(MyPageExhibition(id: i, name: "공예", thumbnailImgUrl: "https://fastly.picsum.photos/id/190/200/300.jpg?hmac=KMqZBOcb2v614PnLYdaZ_nsWFhVgoZrNcnRAiytDbVc", artistName: "김예원"))
        }
    }
}
