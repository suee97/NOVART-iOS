import Combine
import UIKit

final class MyPageViewModel {
    @Published private (set) var selectedCategory: MyPageCategory! {
        didSet {
            print("MyPageViewModel selectedCategory - \(selectedCategory.rawValue)")
        }
    }
    
    var likes = [MyPageLike]()
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
            likes.append(MyPageLike(id: i, name: "탁자", thumbnailImgUrl: "https://loremflickr.com/600/400", artistName: "오승언"))
        }
        for i in 0..<0 {
            likes.append(MyPageLike(id: i, name: "의자", thumbnailImgUrl: "https://loremflickr.com/600/400", artistName: "오승언"))
        }
        for i in 0..<3 {
            likes.append(MyPageLike(id: i, name: "책 표지", thumbnailImgUrl: "https://loremflickr.com/600/400", artistName: "양용수"))
        }
        for i in 0..<40 {
            likes.append(MyPageLike(id: i, name: "공예", thumbnailImgUrl: "https://loremflickr.com/600/400", artistName: "김예원"))
        }
    }
}
