import Foundation
import Combine

final class MyPageProfileEditViewModel {
    // MARK: - Properties
    private let coordinator: MyPageCoordinator
    
    @Published var categoryTagItemSelectCount: Int = 0
    var categoryTagItems = [TagItem]() {
        didSet {
            categoryTagItemSelectCount = calculateSelectionCount(categoryTagItems)
        }
    }
    
    @Published var recommendTagItemSelectCount: Int = 0
    @Published var tagFieldString: String = ""
    var recommendTagItems = [TagItem]()

    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
        getUserInfo()
    }
    
    
    // MARK: - Functions
    private func getUserInfo() {
        
        // 서버에서 데이터를 받아옴
        categoryTagItems = [
            TagItem(tag: "제품 디자이너", isSelected: false), TagItem(tag: "시각 디자이너", isSelected: false),TagItem(tag: "UX 디자이너", isSelected: false), TagItem(tag: "패션 디자이너", isSelected: false), TagItem(tag: "3D 아티스트", isSelected: true), TagItem(tag: "크리에이터", isSelected: false), TagItem(tag: "일러스트레이터", isSelected: false), TagItem(tag: "공예가", isSelected: false), TagItem(tag: "화가", isSelected: false)
        ]
        
        recommendTagItems = [
            TagItem(tag: "제품", isSelected: false), TagItem(tag: "공예", isSelected: false), TagItem(tag: "그래픽", isSelected: false), TagItem(tag: "회화", isSelected: false), TagItem(tag: "UX", isSelected: false), TagItem(tag: "UI", isSelected: false), TagItem(tag: "모던", isSelected: false), TagItem(tag: "클래식", isSelected: false), TagItem(tag: "오브제", isSelected: false), TagItem(tag: "감성적인", isSelected: false), TagItem(tag: "심플", isSelected: false), TagItem(tag: "귀여운", isSelected: false), TagItem(tag: "키치한", isSelected: false), TagItem(tag: "힙한", isSelected: true), TagItem(tag: "레트로", isSelected: false), TagItem(tag: "트렌디", isSelected: false), TagItem(tag: "부드러운", isSelected: false), TagItem(tag: "몽환적인", isSelected: false), TagItem(tag: "실용적인", isSelected: false), TagItem(tag: "빈티지", isSelected: false), TagItem(tag: "화려한", isSelected: false), TagItem(tag: "재활용", isSelected: false), TagItem(tag: "친환경", isSelected: false), TagItem(tag: "지속가능한", isSelected: false), TagItem(tag: "밝은", isSelected: false), TagItem(tag: "어두운", isSelected: false), TagItem(tag: "차가운", isSelected: true), TagItem(tag: "따뜻한", isSelected: false),
        ]
        
        // tagField 초기 텍스트 설정 or 서버에서 받아오기
        var tmpString = ""
        recommendTagItems.filter{$0.isSelected}.forEach{tmpString += "\($0.tag ?? ""), "}
        if !tmpString.isEmpty {
            let tmpIdx = tmpString.index(tmpString.startIndex, offsetBy: tmpString.count - 3)
            tagFieldString = String(tmpString[tmpString.startIndex...tmpIdx])
        } else {
            tagFieldString = ""
        }
        
        updateRecommendTagItemSelectCount()
    }
    
    private func calculateSelectionCount(_ tagItems: [TagItem]) -> Int {
        return tagItems.filter{$0.isSelected}.count
    }
    
    func updateCategoryTagSelection(indexPath: IndexPath, isSelected: Bool) {
        categoryTagItems[indexPath.row].isSelected = isSelected
    }
    
    func updateRecommendTagSelection(indexPath: IndexPath, isSelected: Bool) {
        recommendTagItems[indexPath.row].isSelected = isSelected
        
        // 선택된 추천태그 문자열
        let tagString = recommendTagItems[indexPath.row].tag ?? ""
        
        if isSelected {
            tagFieldString += tagFieldString.isEmpty ? tagString : ", \(tagString)" // 추천태그 추가
        } else {
            // 추천태그 제거
            tagFieldString = tagFieldString.replacingOccurrences(of: ", \(tagString)", with: "")
            tagFieldString = tagFieldString.replacingOccurrences(of: "\(tagString), ", with: "")
            tagFieldString = tagFieldString.replacingOccurrences(of: "\(tagString)", with: "")
        }
        updateRecommendTagItemSelectCount() // 추천태그 선택 변경으로 인한 count update
    }
    
    // 텍스트 필드 ',' 기준으로 태그 개수 카운트
    private func updateRecommendTagItemSelectCount() {
        if tagFieldString.isEmpty {
            recommendTagItemSelectCount = 0
            return
        }
        recommendTagItemSelectCount = tagFieldString.components(separatedBy: ",").count
    }
    
    // 유저의 텍스트필드 입력에 따른 뷰모델 및 UI 동기화
    func tagFieldChangedFromUser() {
        if !tagFieldString.isEmpty {
            let tags = tagFieldString.components(separatedBy: ",").map{$0.trimmingCharacters(in: .whitespaces)}
            
            for i in 0..<recommendTagItems.count {
                let idx = tags.firstIndex(of: recommendTagItems[i].tag ?? "") ?? -1
                recommendTagItems[i].isSelected = (idx != -1)
            }
        }
        updateRecommendTagItemSelectCount()
    }
    
    
    // MARK: - Navigation
    @MainActor
    func showMain() {
        coordinator.navigate(to: .MyPageMain)
    }
}
