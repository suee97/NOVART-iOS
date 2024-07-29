import XCTest
@testable import Plain

final class MyPageProfileEditViewModelTests: XCTestCase {
    var sut: MyPageProfileEditViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let user = PlainUser(id: 0, nickname: "suee97", profileImageUrl: "", backgroundImageUrl: nil, tags: ["UI", "UX"], jobs: [""], email: "cheatz@naver.com", openChatUrl: nil, following: true)
        sut = MyPageProfileEditViewModel(user: user)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_recommendTagItemSelectCount_가_5일때_shouldAddRecommendTagItem_함수가_false를_반환하는지() {
        sut.recommendTagItemSelectCount = 5
        
        let result = sut.shouldAddRecommendTagItem()
        
        XCTAssertEqual(result, false)
    }
    
    func test_recommendTagItemSelectCount_가_2일때_shouldAddRecommendTagItem_함수가_true를_반환하는지() {
        sut.recommendTagItemSelectCount = 2
        
        let result = sut.shouldAddRecommendTagItem()
        
        XCTAssertEqual(result, true)
    }
    
    func test_categoryTagItemSelectCount_가_7일때_shouldAddCategoryTagItem_함수가_false를_반환하는지() {
        sut.categoryTagItemSelectCount = 7
        
        let result = sut.shouldAddCategoryTagItem()
        
        XCTAssertEqual(result, false)
    }
    
    func test_categoryTagItemSelectCount_가_1일때_shouldAddCategoryTagItem_함수가_true를_반환하는지() {
        sut.categoryTagItemSelectCount = 1
        
        let result = sut.shouldAddCategoryTagItem()
        
        XCTAssertEqual(result, true)
    }
}

