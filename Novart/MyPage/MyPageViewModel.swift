import Foundation
import Combine

final class MyPageViewModel {
    @Published private (set) var selectedCategory: MyPageCategory! {
        didSet {
            print("MyPageViewModel selectedCategory - \(selectedCategory.rawValue)")
        }
    }
    
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
}
